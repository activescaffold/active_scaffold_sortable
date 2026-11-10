# frozen_string_literal: true

module ActiveScaffoldSortable
  module ViewHelpers
    def sort_params(config = active_scaffold_config)
      options = {
        tag: '> tr',
        format: '^[^_-](?:[A-Za-z0-9_-]*)-(.*)-row$',
        column: config.sortable.column.name
      }
      if config == active_scaffold_config
        options[:reorder_url] = url_for(params_for(action: :reorder, controller: controller_name))
      end
      options.merge config.sortable.options
    end

    def active_scaffold_sortable_column(record, column)
      ''
    end
  end
end
