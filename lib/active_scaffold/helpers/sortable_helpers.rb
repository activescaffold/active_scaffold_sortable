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
      'sortable'
    end
  end
end
