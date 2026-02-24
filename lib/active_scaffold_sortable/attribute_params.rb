module ActiveScaffoldSortable
  module AttributeParams
    def update_column_from_params(parent_record, column, attribute, avoid_changes = false)
      super.tap do |value|
        if column.association.try(:collection?)
          config = active_scaffold_config_for(column.association.klass)
          if config.actions.include?(:sortable)
            sortable_col = config.sortable.column.name
            max_value = value.map(&sortable_col).compact.max
            value.each { |record| record.send("#{sortable_col}=", max_value += 1) unless record.send(sortable_col) }
            parent_record.association(column.association.name).target = value.sort_by(&sortable_col)
          end
        end
      end
    end
  end
end
