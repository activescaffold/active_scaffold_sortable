# frozen_string_literal: true

class HandleModelsController < ApplicationController
  active_scaffold :handle_model do |config|
    config.actions << :sortable
    config.sortable.column = :position
    config.sortable.add_handle_column = :first
    config.list.empty_field_text = "\u00A0"
  end
end
