module ActiveScaffoldSortable
  module ViewHelpers
    def self.included(base)
      base.alias_method_chain :active_scaffold_stylesheets, :sortable
    end

    def active_scaffold_stylesheets_with_sortable(frontend = :default)
      active_scaffold_stylesheets_without_sortable(frontend) + [ActiveScaffold::Config::Core.asset_path('sortable.css', frontend)]
    end
  end
end
