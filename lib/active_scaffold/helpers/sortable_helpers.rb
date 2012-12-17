module ActiveScaffold::Helpers
  module SortableHelpers
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
  end
end
