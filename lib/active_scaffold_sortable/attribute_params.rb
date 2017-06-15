module ActiveScaffoldSortable
  module AttributeParams
    def update_column_from_params(parent_record, column, attribute, avoid_changes = false)
      super.tap do |value|
        if column.association.try(:collection?)
          config = active_scaffold_config_for(column.association.klass)
          if config.actions.include?(:sortable)
            parent_record.association(column.association.name).target = value.sort_by(&config.sortable.column.name)
          end
        end
      end
    end
  end
end
