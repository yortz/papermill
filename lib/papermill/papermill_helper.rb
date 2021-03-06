# encoding: utf-8

module PapermillHelper
  
  # Sets all the javascript needed for papermill.
  # If you already loaded jQuery and JQueryUI, call papermill_javascript_tag
  # If you don't use jQuery or use some other library, call papermill_javascript_tag(:with_jquery => "no_conflict")
  # If you want to rely on this helper to load jQuery/jQueryUI and use it, call papermill_javascript_tag(:with_jquery => true)
  # If you loaded jQuery and need to load only jQueryUI, call papermill_javascript_tag(:with_jqueryui_only => true)
  def papermill_javascript_tag(options = {})
    html = []
    if options[:with_jquery] || options[:with_jqueryui]
      html << %{<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js" type="text/javascript"></script>} if options[:with_jquery]
      html << %{<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.min.js" type="text/javascript"></script>} if options[:with_jquery] || options[:with_jqueryui_only]
      html << %{<script type="text/javascript">jQuery.noConflict();</script>} if options[:with_jquery] == "no_conflict"
    end
    html << %{<script type="text/javascript">}
    ["SWFUPLOAD_PENDING", "SWFUPLOAD_LOADING"].each do |js_constant|
      html << %{var #{js_constant} = "#{t("papermill.#{js_constant}")}";}
    end
    html << %{</script>}
    html << javascript_include_tag("/papermill/papermill", "/papermill/swfupload")
    unless @content_for_papermill_inline_js.blank?
      html << '<script type="text/javascript">'
      html << '//<![CDATA['
      html << 'jQuery(document).ready(function() {'
      html << @content_for_papermill_inline_js
      html << '});'
      html << '//]]>'
      html << '</script>'
    end
    html.join("\n")
  end
  
  # Sets the css tags needed for papermill.
  def papermill_stylesheet_tag(options = {})
    html = []
    html << stylesheet_link_tag("/papermill/papermill")
    unless @content_for_papermill_inline_css.blank?
      html << %{<style type="text/css">}
      html << @content_for_papermill_inline_css
      html << %{</style>}
    end
    html.join("\n")
  end
end