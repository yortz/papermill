# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{papermill}
  s.version = "0.5.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Benoit B\303\251n\303\251zech"]
  s.date = %q{2009-09-07}
  s.description = %q{Paperclip Swfupload UploadHelper wrapper}
  s.email = %q{benoit.benezech@gmail.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "MIT-LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "app/controllers/papermill_controller.rb",
     "app/views/papermill/_asset.html.erb",
     "app/views/papermill/_raw_asset.html.erb",
     "app/views/papermill/_thumbnail_asset.html.erb",
     "app/views/papermill/edit.html.erb",
     "config/locales/papermill.yml",
     "config/routes.rb",
     "generators/papermill/USAGE",
     "generators/papermill/papermill_generator.rb",
     "generators/papermill/templates/migrate/papermill_migration.rb.erb",
     "init.rb",
     "install.rb",
     "installation-template.txt",
     "lib/core_extensions.rb",
     "lib/papermill.rb",
     "lib/papermill/form_builder.rb",
     "lib/papermill/papermill_asset.rb",
     "lib/papermill/papermill_helper.rb",
     "lib/papermill/papermill_module.rb",
     "papermill.gemspec",
     "public/.DS_Store",
     "public/flashs/swfupload.swf",
     "public/images/.DS_Store",
     "public/images/papermill/.DS_Store",
     "public/images/papermill/background.png",
     "public/images/papermill/container-background.jpg",
     "public/images/papermill/delete.png",
     "public/images/papermill/upload-blank.png",
     "public/images/papermill/upload.png",
     "public/javascripts/papermill.js",
     "public/stylesheets/papermill.css",
     "rails/init.rb",
     "tasks/papermill_tasks.rake",
     "test/papermill_test.rb",
     "test/test_helper.rb",
     "uninstall.rb"
  ]
  s.homepage = %q{http://github.com/BBenezech/papermill}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Paperclip Swfupload UploadHelper wrapper}
  s.test_files = [
    "test/papermill_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<paperclip>, [">= 2.1.2"])
      s.add_runtime_dependency(%q<mime-types>, [">= 1.16"])
      s.add_runtime_dependency(%q<rsl-stringex>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<ryanb-acts-as-list>, [">= 0.1.2"])
    else
      s.add_dependency(%q<paperclip>, [">= 2.1.2"])
      s.add_dependency(%q<mime-types>, [">= 1.16"])
      s.add_dependency(%q<rsl-stringex>, [">= 1.0.0"])
      s.add_dependency(%q<ryanb-acts-as-list>, [">= 0.1.2"])
    end
  else
    s.add_dependency(%q<paperclip>, [">= 2.1.2"])
    s.add_dependency(%q<mime-types>, [">= 1.16"])
    s.add_dependency(%q<rsl-stringex>, [">= 1.0.0"])
    s.add_dependency(%q<ryanb-acts-as-list>, [">= 0.1.2"])
  end
end
