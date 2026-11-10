# frozen_string_literal: true

module ActiveScaffoldSortable
  module Core
    def initialize(model_id)
      super
      return unless model.method_defined?(:acts_as_list_class) || model.method_defined?(:nested_set_scope)

      actions << :sortable
      sortable # force to load
    end
  end
end
