# frozen_string_literal: true

module ActiveScaffoldSortable
  class Engine < ::Rails::Engine
    initializer 'active_scaffold_sortable.routes' do
      ActiveSupport.on_load :active_scaffold_routing do
        self::ACTIVE_SCAFFOLD_CORE_ROUTING[:collection][:reorder] = :post
      end
    end

    initializer 'active_scaffold_sortable.action_view' do
      ActiveSupport.on_load :action_view do
        ActiveSupport.on_load(:action_view) { include ActiveScaffoldSortable::ViewHelpers }
      end
    end

    initializer 'active_scaffold_sortable.extensions' do
      ActiveScaffold::Config::Core.prepend ActiveScaffoldSortable::Core
      ActiveScaffold::AttributeParams.prepend ActiveScaffoldSortable::AttributeParams
    end
  end
end
