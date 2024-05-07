require "active_scaffold_sortable/engine.rb"

module ActiveScaffoldSortable
  def self.root
    File.dirname(__FILE__) + "/.."
  end
  autoload 'Core', 'active_scaffold_sortable/core.rb'
  autoload 'ViewHelpers', 'active_scaffold_sortable/view_helpers.rb'
  autoload 'AttributeParams', 'active_scaffold_sortable/attribute_params.rb'
end
