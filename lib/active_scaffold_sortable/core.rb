module ActiveScaffoldSortable
  module Core
    def initialize(model_id)
      super
      # seems some rubies are returning strings in instance_methods and other symbols...
      if !(model.instance_methods & ['acts_as_list_class', :acts_as_list_class, 'nested_set_scope', :nested_set_scope]).empty?
        self.actions << :sortable
        self.sortable # force to load
      end
    end
  end
end
