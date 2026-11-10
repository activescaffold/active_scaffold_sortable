# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'active_scaffold_sortable/version'

Gem::Specification.new do |s|
  s.name = 'active_scaffold_sortable'
  s.version = ActiveScaffoldSortable::Version::STRING

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.authors = ['Sergio Cambra', 'Volker Hochstein']
  s.summary = 'Drag n Drop Sorting for Activescaffold'
  s.description = 'Sort Tree or List Structures by Drag n Drop'
  s.email = 'activescaffold@googlegroups.com'
  s.homepage = 'http://github.com/activescaffold/active_scaffold_sortable'
  s.extra_rdoc_files = [
    'LICENSE.txt',
    'README.md'
  ]
  s.files = Dir['{app,frontends,lib}/**/*'] + %w[LICENSE.txt README.md]
  s.licenses = ['MIT']
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 3.2'

  s.add_dependency('active_scaffold', ['>= 4.4.0'])
  s.metadata['rubygems_mfa_required'] = 'true'
end
