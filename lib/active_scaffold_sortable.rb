require "active_scaffold_sortable/config/core.rb"
require "active_scaffold_sortable/core.rb"
require "active_scaffold_sortable/engine.rb" unless defined? ACTIVE_SCAFFOLD_SORTABLE_PLUGIN

module ActiveScaffoldSortable
  def self.root
    File.dirname(__FILE__) + "/.."
  end
  autoload 'ViewHelpers', 'active_scaffold_sortable/view_helpers.rb'
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
ActionView::Base.send :include, ActiveScaffoldSortable::ViewHelpers
ActiveScaffold::Config::Core.send :include, ActiveScaffoldSortable::Core
ActiveScaffold.stylesheets << 'active_scaffold_sortable'
ActiveScaffold.javascripts << 'active_scaffold_sortable'
