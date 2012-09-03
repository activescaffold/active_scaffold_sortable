module ActiveScaffold::Helpers
  module SortableHelpers
    def sort_params
      options = {
        :tag => 'tr', 
        :url => {:action => :reorder, :controller => controller_name },
        :format => '/^[^_-](?:[A-Za-z0-9_-]*)-(.*)-row$/',
        :with => "Sortable.serialize(#{active_scaffold_tbody_id.to_json})"
      }
      additional_params = [:parent_controller, :eid, :controller].reject {|param| params[param].blank?}
      options[:with] = additional_params.inject(options[:with]) do |string, param|
        "#{string} + '&#{param}=' + encodeURIComponent('#{escape_javascript params[param]}')"
      end
      options.merge! active_scaffold_config.sortable.options

      [active_scaffold_tbody_id, options]
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
