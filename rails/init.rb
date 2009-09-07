require 'core_extensions'
Object.send :include, ObjectExtensions
Hash.send :include, HashExtensions
String.send :include, StringExtensions

I18n.load_path = [File.join(File.dirname(__FILE__), "../config/locales/papermill.yml")] + I18n.load_path

require 'papermill/papermill_module'
require 'papermill/papermill_asset'
require 'papermill/form_builder'
require 'papermill/papermill_helper'
ActionView::Base.send :include, PapermillHelper
ActiveRecord::Base.send :include, Papermill