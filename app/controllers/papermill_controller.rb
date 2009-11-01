class PapermillController < ApplicationController
  # Create is protected because of the Ajax same origin policy. 
  # Yet SwfUpload doesn't send the right header for request.xhr? to be true and thus fails to disable verify_authenticity_token automatically.
  skip_before_filter :verify_authenticity_token, :only => [:create]
  
  def show
    @asset = PapermillAsset.find_by_id_partition(params)
    if (@asset.create_thumb_file(params[:style]) rescue nil)
      redirect_to @asset.url(params[:style])
    else
      render :text => t('papermill.not-found'), :status => "404"
    end
  end

  def destroy
    @asset = PapermillAsset.find_by_id(params[:id])
    render :update do |page|
      if @asset && @asset.destroy
        page << "jQuery('#papermill_asset_#{params[:id]}').remove()"
      else
        page << "jQuery('#papermill_asset_#{params[:id]}').show()"
        page << %{ notify("#{t((@asset && "papermill.not-deleted" || "papermill.not-found"), :ressource => @asset.name)}", "error") }
      end
    end
  end
  
  def update
    @asset = PapermillAsset.find_by_id(params[:id])
    render :update do |page|
      if @asset && @asset.update_attributes(params[:papermill_asset])
        page << %{ notify("#{t("papermill.updated", :ressource => @asset.name)}", "notice") }
      else
        page << %{ notify("#{@asset && @asset.errors.full_messages.to_sentence || t("papermill.not-found", :ressource => params[:id].to_s)}", "warning") }
      end
    end
  end
  
  def edit
    @asset = PapermillAsset.find params[:id]
  end
  
  def create
    asset_class = params[:asset_class].constantize
    params[:assetable_id]   = params[:assetable_id].try :to_i
    params[:assetable_type] = params[:assetable_type].try :camelize
    params[:assetable_key]  = params[:assetable_key].try :to_s
    unless params[:gallery]
      @old_asset = asset_class.find(:first, :conditions => params.reject{|k, v| !["assetable_key", "assetable_type", "assetable_id"].include?(k)})
    end
    @asset = asset_class.new(params.reject{|k, v| !(PapermillAsset.columns.map(&:name)+["file_data"]).include?(k)})
    
    if @asset.save
      @old_asset.destroy if @old_asset
      render :partial => "papermill/asset", :object => @asset, :locals => {:gallery => params[:gallery], :thumbnail_style => params[:thumbnail_style]}
    else
      render :text => @asset.errors.full_messages.join('<br />'), :status => "500"
    end
  end
  
  def sort
    params[:papermill_asset].each_with_index do |id, index|
      PapermillAsset.find(id).update_attribute(:position, index + 1)
    end
    render :nothing => true
  end
end