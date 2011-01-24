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

        dir = File.join(ActiveScaffold::Config::Sortable.plugin_directory, 'frontends')
        base.add_active_scaffold_path File.join(dir, frontend, 'views') if config.frontend.to_sym != :default
        base.add_active_scaffold_path File.join(dir, 'default', 'views')
      end
    end
    
    def reorder
      model = active_scaffold_config.model
      
      unless (model.instance_methods & [:nested_set_scope, 'nested_set_scope']).empty?
        reorder_children_in_tree(model)
      else
        if model.respond_to? :ancestry_column
          reorder_ancestry_tree(model) 
        else
          reorder_simple_list(model)
        end
      end
    end
    
    protected
    def sortable_authorized?
      authorized_for?(:action => :update)
    end
    
    def reorder_ancestry_tree(model)
      first_record = model.find(params[active_scaffold_tbody_id].first)
      unless first_record.nil?
        records = first_record.is_root? ? model.roots: first_record.parent.children
        reorder_simple_list(model)
      else
        Rails.logger.info("Failed to find first record to reorder")
      end
    end
    
    def reorder_simple_list(model)
      column_name = active_scaffold_config.sortable.column.name
      params[active_scaffold_tbody_id].each_with_index do |id, index|
        model.update_all({column_name => index + 1}, {model.primary_key => id})
      end
    end
    
    def reorder_children_in_tree(model)
      current_order = model.find(params[active_scaffold_tbody_id].first).try(:self_and_siblings)
      new_order = params[active_scaffold_tbody_id].collect {|item_id| item_id.to_i}
      new_order.each_with_index do |record_id, new_position|
        if record_id != current_order[new_position].id
          current_order = move_child(current_order.find {|child| child.id == record_id}, new_position, current_order) 
        end
      end if new_order.length == current_order.length
    end
    
    def move_child(child, new_position, children)
      old_position = children.index(child)
      (old_position - new_position).abs.times do |step|
        child.send((old_position - new_position) > 0 ? :move_left : :move_right)
      end
      child.self_and_siblings
    end

  end
end
