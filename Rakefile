require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
require './lib/active_scaffold_sortable/version.rb'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "active_scaffold_sortable_vho"
  gem.version = ActiveScaffoldSortable::Version::STRING
  gem.homepage = "http://github.com/vhochstein/active_scaffold_sortable"
  gem.license = "MIT"
  gem.summary = %Q{Drag n Drop Sorting for Activescaffold}
  gem.description = %Q{Sort Tree or List Structures by Drag n Drop}
  gem.email = "activescaffold@googlegroups.com"
  gem.authors = ["Volker Hochstein"]
  gem.add_runtime_dependency 'active_scaffold_vho', '~> 3.0'
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
desc 'Test plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
desc 'Generate documentation for plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "active_scaffold_sortable #{ActiveScaffoldSortable::Version::STRING}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
