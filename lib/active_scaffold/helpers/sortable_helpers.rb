module ActiveScaffold::Helpers
  module SortableHelpers
    def sort_params
      options = {
        :tag => 'tr', 
        :reorder_url => url_for(params_for(:action => :reorder, :controller => controller_name)),
        :format => '^[^_-](?:[A-Za-z0-9_-]*)-(.*)-row$',
        :update => true
      }
      options.merge active_scaffold_config.sortable.options
    end

    def list_row_class(record)
      "#{'sortable-handle' unless active_scaffold_config.sortable.add_handle_column} #{super}"
    end

    def column_class(column, column_value, record)
      if column == :active_scaffold_sortable
        'sortable-handle'
      else
        super
      end
    end

    def active_scaffold_sortable_column(record, column)
      ''
    end
  end
end
