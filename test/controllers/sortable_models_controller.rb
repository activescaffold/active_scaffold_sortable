class SortableModelsController < ActionController::Base
  active_scaffold :model do |config|
    config.actions << :sortable
    config.sortable.column = :name
  end
end
