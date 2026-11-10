# frozen_string_literal: true

class SortableModelsController < ApplicationController
  active_scaffold :model do |config|
    config.actions.exclude :search
    config.actions << :sortable
    config.sortable.column = :name
  end
end
