module Sortable::Core
  def self.included(base)
    base.alias_method_chain :initialize, :sortable
  end

  def initialize_with_sortable(model_id)
    initialize_without_sortable(model_id)
    self.actions << :sortable if model.instance_methods.include? 'acts_as_list_class'
  end
end
