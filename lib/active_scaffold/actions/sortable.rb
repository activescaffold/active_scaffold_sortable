module ActiveScaffold::Actions
  module Sortable
    def self.included(base)
      base.helper ActiveScaffold::Helpers::SortableHelpers
      base.before_filter :sortable_authorized?, :only => :reorder
      base.active_scaffold_config.configure do |config|
        config.list.pagination = false
      
        # turn sorting off
        sortable_column = config.sortable.column.name
        config.columns.each {|c| c.sort = false unless c.name == sortable_column }
        config.list.sorting = { sortable_column => "asc" }
      
        config.actions.each do |action_name|
          action = config.send(action_name)
          action.columns.exclude(sortable_column) if action.respond_to? :columns
        end

        dir = File.join(Rails.root, 'vendor', 'plugins', ::Sortable.plugin_name, 'frontends')
        base.add_active_scaffold_path File.join(dir, frontend, 'views') if config.frontend.to_sym != :default
        base.add_active_scaffold_path File.join(dir, 'default', 'views')
      end
    end
    
    def reorder
      model = active_scaffold_config.model
      column_name = active_scaffold_config.sortable.column.name

      params[active_scaffold_tbody_id].each_with_index do |id, index|
        model.update_all({column_name => index + 1}, {model.primary_key => id})
      end
    end
    
    protected
    def sortable_authorized?
      authorized_for?(:action => :update)
    end
  end
end
