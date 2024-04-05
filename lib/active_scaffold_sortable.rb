require "active_scaffold_sortable/engine.rb"

module ActiveScaffoldSortable
  def self.root
    File.dirname(__FILE__) + "/.."
  end
  autoload 'Core', 'active_scaffold_sortable/core.rb'
  autoload 'ViewHelpers', 'active_scaffold_sortable/view_helpers.rb'
  autoload 'AttributeParams', 'active_scaffold_sortable/attribute_params.rb'
end

module ActiveScaffold
  module Actions
    ActiveScaffold.autoload_subdir('actions', self, File.dirname(__FILE__))
  end

  module Config
    ActiveScaffold.autoload_subdir('config', self, File.dirname(__FILE__))
  end

  module Helpers
    ActiveScaffold.autoload_subdir('helpers', self, File.dirname(__FILE__))
  end
end
ActiveScaffold.stylesheets << 'active_scaffold_sortable'
ActiveScaffold.javascripts << 'active_scaffold_sortable'
