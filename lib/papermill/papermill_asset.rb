require 'paperclip'

class PapermillAsset < ActiveRecord::Base
  
  before_destroy :destroy_files
  before_create :set_position
  
  has_attached_file :file, 
    :path => "#{Papermill::PAPERMILL_DEFAULTS[:public_root]}/#{Papermill::PAPERMILL_DEFAULTS[:papermill_prefix]}/#{Papermill::PAPERCLIP_INTERPOLATION_STRING}",
    :url => "/#{Papermill::PAPERMILL_DEFAULTS[:papermill_prefix]}/#{Papermill::PAPERCLIP_INTERPOLATION_STRING}"
  
  validates_attachment_presence :file
  
  belongs_to :assetable, :polymorphic => true
  default_scope :order => 'position'
  
  def Filedata=(data)
    self.file = data
    self.file_content_type = data.get_content_type
  end
  
  def Filename=(name)
    self.title = name
  end
  
  def create_thumb_file(style_name)
    FileUtils.mkdir_p File.dirname(file.path(style_name))
    FileUtils.mv(Paperclip::Thumbnail.make(file, self.class.compute_style(style_name)).path, file.path(style_name))
  end
  
  def id_partition
    ("%09d" % self.id).scan(/\d{3}/).join("/")
  end
  
  def self.find_by_id_partition(params)
    self.find((params[:id0] + params[:id1] + params[:id2]).to_i)
  end
  
  def name
    file_file_name
  end
  
  def width
    Paperclip::Geometry.from_file(file).width
  end
  
  def height
    Paperclip::Geometry.from_file(file).height
  end
  
  def size
    file_file_size
  end

  def url(style = nil)
    file.url(style && CGI::escape(style.to_s))
  end
  
  def path(style = nil)
    file.path(style)
  end
  
  def content_type
    file_content_type
  end
  
  def image?
    content_type.split("/")[0] == "image"
  end
  
  def save(*params)
    if super(*params)
      if params.last.is_a?(Hash) && params.last[:unique]
        PapermillAsset.find(:all, :conditions => {:assetable_id => assetable_id, :assetable_type => assetable_type, :assetable_key => assetable_key }).each do |asset|
          asset.destroy unless asset == self
        end
      end
      true
    else
      false
    end
  end
  
  private
  def set_position
    self.position ||= self.class.find(:first, :conditions => ["assetable_key = ? AND assetable_type = ? AND assetable_id = ?", assetable_key, assetable_type, assetable_id], :order => "position DESC" ).try(:position).to_i + 1
  end
  
  def destroy_files
    FileUtils.rm_r(File.dirname(path).chomp("original")) rescue true
  end
  
  def self.compute_style(style)
    style = Papermill::PAPERMILL_DEFAULTS[:aliases][style.to_sym] || Papermill::PAPERMILL_DEFAULTS[:aliases][style.to_s] || !Papermill::PAPERMILL_DEFAULTS[:alias_only] && style
    [Symbol, String].include?(style.class) ? {:geometry => style.to_s} : style
  end  
end
