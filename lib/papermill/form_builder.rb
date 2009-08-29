class ActionView::Helpers::FormBuilder
  
  def assets_upload(key = nil, method = nil, options = {})
    papermill_upload_field key, method, { :thumbnail => false }.update(options)
  end
  def asset_upload(key = nil, method = nil, options = {})
    papermill_upload_field key, method, { :gallery => false, :thumbnail => false }.update(options)
  end
  def images_upload(key = nil, method = nil, options = {})
    papermill_upload_field key, method, options
  end
  def image_upload(key = nil, method = nil, options = {})
    papermill_upload_field key, method, { :gallery => false }.update(options)
  end

  private
  def papermill_upload_field(key, method, options = {})
    assetable = @template.instance_variable_get("@#{@object_name}")
    method ||= options[:association] || :papermill_assets
    key ||= options[:key] || nil
    options = assetable.class.papermill_options.deep_merge(options)
    assetable_id = assetable.id || assetable.timestamp
    assetable_type = assetable.class.to_s.underscore
    id = "papermill_#{assetable_type}_#{assetable_id}_#{key}_#{method}"
    if options[:thumbnail] 
      w = options[:thumbnail][:width]  || options[:thumbnail][:height] && options[:thumbnail][:aspect_ratio] && (options[:thumbnail][:height] * options[:thumbnail][:aspect_ratio]).to_i || nil
      h = options[:thumbnail][:height] || options[:thumbnail][:width]  && options[:thumbnail][:aspect_ratio] && (options[:thumbnail][:width]  / options[:thumbnail][:aspect_ratio]).to_i || nil
      options[:thumbnail][:style] ||= (w || h) && "#{w || options[:thumbnail][:max_width]}x#{h || options[:thumbnail][:max_height]}>" || "original"
      if options[:thumbnail][:inline_css]
        size = []
        size << "width:#{w}px" if w
        size << "height:#{h}px" if h
        size = size.join("; ")
        @template.content_for :inline_css do
          inline_css = ["\n"]
          if options[:gallery]
            vp = options[:gallery][:vpadding].to_i
            hp = options[:gallery][:hpadding].to_i
            vm = options[:gallery][:vmargin].to_i
            hm = options[:gallery][:hmargin].to_i
            b  = options[:gallery][:border_thickness].to_i
            gallery_width = (options[:gallery][:width] || w) && "width:#{options[:gallery][:width] || options[:gallery][:columns]*(w+(hp+hm+b)*2)}px;" || ""
            gallery_height = (options[:gallery][:height] || h) && "#{options[:gallery][:autogrow] ? "" : "min-"}height:#{options[:gallery][:height] || options[:gallery][:lines]*(h+(vp+vm+b)*2)}px;" || ""
            inline_css << %{##{id} { #{gallery_width} #{gallery_height} }}
            inline_css << %{##{id} li { margin:#{vm}px #{hm}px; border-width:#{b}px; padding:#{vp}px #{hp}px; #{size}; }}
          else
            inline_css << %{##{id}, ##{id} li { #{size} }}
          end
          inline_css << %{##{id} .name { width:#{w || "100"}px; }}
          inline_css.join("\n")
        end
      end
    end
    create_url = @template.url_for(:controller => "/papermill", :action => "create", :escape => false, :association => method.to_s, :assetable_key => key, :assetable_id => assetable_id, :assetable_type => assetable_type, :gallery => (options[:gallery] != false), :thumbnail_style => (options[:thumbnail] && options[:thumbnail][:style]))
    html = []
    if assetable.new_record? && !@timestamped
      html << self.hidden_field(:timestamp, :value => assetable.timestamp)
      @timestamped = true
    end
    html << %{<div style="height: #{options[:swfupload][:button_height]}px;"><span id="browse_for_#{id}" class="swf_button"></span></div>}
    conditions = {:assetable_type => assetable.class.sti_name, :assetable_id => assetable_id}
    conditions.merge!({:assetable_key => key.to_s}) if key
    html << @template.content_tag(:ul, :id => id, :class => "papermill #{(options[:thumbnail] ? "papermill-thumb-container" : "papermill-asset-container")} #{(options[:gallery] ? "papermill-multiple-items" : "papermill-unique-item")}") {
      @template.render :partial => "papermill/asset", :collection => assetable.class.papermill_associations[method][:class].find(:all, :conditions => conditions, :order => "position"), :locals => { :thumbnail_style => (options[:thumbnail] && options[:thumbnail][:style]) }
    }
    @template.content_for :inline_js do
      %{
        #{%{$("##{id}").sortable({update:function(){jQuery.ajax({async:true, data:jQuery(this).sortable('serialize'), dataType:'script', type:'post', url:'#{@template.controller.send("sort_papermill_url")}'})}})} if options[:gallery]}
        new SWFUpload({
          upload_id: "#{id}",
          upload_url: "#{@template.escape_javascript create_url}",
          file_size_limit: "#{options[:file_size_limit_mb].megabytes}",
          file_types: "#{options[:images_only] ? '*.jpg;*.jpeg;*.png;*.gif' : ''}",
          file_types_description: "#{options[:thumbnail] ? 'Images' : 'Files'}",
          file_queue_limit: "#{!options[:gallery] ? '1' : '0'}",
          file_queued_handler: Upload.file_queued,
          file_dialog_complete_handler: Upload.file_dialog_complete,
          upload_start_handler: Upload.upload_start,
          upload_progress_handler: Upload.upload_progress,
          upload_error_handler: Upload.upload_error,
          upload_success_handler: Upload.upload_success,
          upload_complete_handler: Upload.upload_complete,
          button_placeholder_id : "browse_for_#{id}",
          #{options[:swfupload].map{ |key, value| ["false", "true"].include?(value.to_s) ? "#{key.to_s}: #{value.to_s}" : "#{key.to_s}: '#{value.to_s}'"  }.compact.join(", ")}
        });
      }
  	end
  	html.reverse! if options[:button_after_container]
	  html.join("\n")
  end
end