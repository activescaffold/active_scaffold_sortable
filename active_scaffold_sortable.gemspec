# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'active_scaffold_sortable/version'

Gem::Specification.new do |s|
  s.name = %q{active_scaffold_sortable}
  s.version = ActiveScaffoldSortable::Version::STRING

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sergio Cambra", "Volker Hochstein"]
  s.summary = %q{Drag n Drop Sorting for Activescaffold}
  s.description = %q{Sort Tree or List Structures by Drag n Drop}
  s.email = %q{activescaffold@googlegroups.com}
  s.homepage = %q{http://github.com/activescaffold/active_scaffold_sortable}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.textile"
  ]
  s.files = Dir["{app,frontends,lib}/**/*"] + %w[LICENSE.txt README.textile]
  s.test_files = Dir["test/**/*"]
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 2.0'

  s.add_runtime_dependency(%q<active_scaffold>, [">= 3.3.0.rc3"])
  s.add_runtime_dependency(%q<rails>, [">= 4.0"])
end

