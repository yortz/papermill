require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the papermill plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the papermill plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Papermill'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "papermill"
    gemspec.summary = "Paperclip Swfupload UploadHelper wrapper"
    gemspec.description = "Paperclip Swfupload UploadHelper wrapper"
    gemspec.email = "benoit.benezech@gmail.com"
    gemspec.homepage = "http://github.com/BBenezech/papermill"
    gemspec.authors = ["Benoit Bénézech"]
    gemspec.add_dependency('paperclip', '>= 2.1.2')
    gemspec.add_dependency('mime-types', '>= 1.16')
    gemspec.add_dependency('rsl-stringex', '>= 1.0.0')
    gemspec.add_dependency('ryanb-acts-as-list', '>= 0.1.2')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end