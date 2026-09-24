# frozen_string_literal: true

class AncestryModelsController < ActionController::Base
  active_scaffold :ancestry_model do |config|
    config.actions << :sortable
    config.sortable.column = :position
  end
end
