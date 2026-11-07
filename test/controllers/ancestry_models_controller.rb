# frozen_string_literal: true

class AncestryModelsController < ActionController::Base
  active_scaffold :ancestry_model do |config|
    config.actions << :sortable
    config.sortable.column = :position
    config.subform.columns = [:name]
    config.update.columns.add_subgroup "Children" do |group|
      group.add :children
      group.tabbed_by = :name
    end
  end
end
