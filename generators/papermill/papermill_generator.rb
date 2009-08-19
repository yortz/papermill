class PapermillGenerator < Rails::Generator::NamedBase
  attr_accessor :class_name, :migration_name
  
  def initialize(args, options = {})
    super
    @class_name = args[0]
  end
  
  def manifest
    @migration_name = file_name.camelize
    record do |m|
      # Migration creation
      m.migration_template "migrate/papermill_migration.rb.erb", "db/migrate", :migration_file_name => migration_name.underscore
    end
  end 
end
