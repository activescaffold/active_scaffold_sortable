module ActiveScaffoldSortable
  module AttributeParams
    def self.included(base)
      base.alias_method_chain :update_column_from_params, :sortable
    end

    def update_column_from_params_with_sortable(parent_record, column, attribute, avoid_changes = false)
      update_column_from_params_without_sortable(parent_record, column, attribute, avoid_changes).tap do |value|
        if column.association.collection?
          config = active_scaffold_config_for(column.association.klass)
          if config.actions.include?(:sortable)
            parent_record.association(column.association.name).target = value.sort_by(&config.sortable.column.name)
          end
        end
      end
    end
  end
end
