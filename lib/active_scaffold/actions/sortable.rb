# frozen_string_literal: true

module ActiveScaffold::Actions
  module Sortable
    def self.included(base)
      base.helper ActiveScaffold::Helpers::SortableHelpers
      base.before_action :sortable_authorized?, only: :reorder
      base.active_scaffold_config.configure do |config|
        config.list.pagination = false if config.actions.include? :list

        # turn sorting off
        sortable_column = config.sortable.column.name
        config.columns.each { |c| c.sort = false unless c.name == sortable_column }
        config.list.sorting = {sortable_column => 'asc'} if config.actions.include? :list

        config.actions.each do |action_name|
          next if action_name == :subform

          action = config.send(action_name)
          action.columns.exclude(sortable_column) if action.respond_to? :columns
        end

        sortable_views_path = File.join(ActiveScaffold::Config::Sortable.plugin_directory, 'frontends', 'default')
        base.add_active_scaffold_path sortable_views_path
      end
    end

    def reorder
      model = active_scaffold_config.model

      if model.instance_methods.intersect?([:nested_set_scope, 'nested_set_scope'])
        reorder_children_in_tree(model)
      elsif model.respond_to? :ancestry_column
        reorder_ancestry_tree(model)
      else
        reorder_simple_list(model)
      end
      do_refresh_list if active_scaffold_config.sortable.refresh_list
    end

    protected

    def sortable_authorized?
      authorized_for?(action: :update)
    end

    def reorder_ancestry_tree(model)
      first_record = model.find(ordered_ids.first)
      if first_record.nil?
        Rails.logger.info('Failed to find first record to reorder')
      else
        records = first_record.is_root? ? model.roots : first_record.parent.children
        reorder_simple_list(records)
      end
    end

    def reorder_simple_list(model)
      updates = ActiveScaffold::OrmChecks.columns_hash(model)['updated_at'] ? {updated_at: Time.zone.now} : {}
      column_name = active_scaffold_config.sortable.column.name
      # Position updates must not trigger model callbacks while the ordering is temporarily inconsistent.
      # rubocop:disable Rails/SkipsModelValidations
      ordered_ids.each.with_index do |id, index|
        updates[column_name] = index + 1
        model.where(model.primary_key => id).update_all(updates)
      end
      # rubocop:enable Rails/SkipsModelValidations
    end

    def reorder_children_in_tree(model)
      full_order = model.find(ordered_ids.first).try(:self_and_siblings)
      new_order = ordered_ids.collect(&:to_i)
      current_order = relevant_order(full_order, new_order)

      return unless new_order.length == current_order.length

      new_order.each_with_index do |record_id, new_position|
        child = full_order.find { |child| child.id == record_id }
        while record_id != current_order[new_position].id
          full_order = move_child(child, current_order.index(child), new_position)
          current_order = relevant_order(full_order, new_order)
        end
      end
    end

    def relevant_order(full_order, new_order)
      return full_order if full_order.length == new_order.length

      full_order.select { |record| new_order.include? record.id }
    end

    def move_child(child, old_position, new_position)
      method = (old_position - new_position).positive? ? :move_left : :move_right
      (old_position - new_position).abs.times { |_| child.send(method) }
      child.self_and_siblings
    end

    def ordered_ids
      @ordered_ids ||= params.delete active_scaffold_tbody_id
    end
  end
end
