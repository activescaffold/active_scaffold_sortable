# frozen_string_literal: true

require 'test_helper'

class HandleModelsControllerTest < ActionController::TestCase
  tests HandleModelsController

  setup do
    HandleModel.delete_all
    HandleModel.create!(name: 'first', position: 1)
  end

  test 'renders an empty drag-handle column with the sortable class' do
    get :index

    assert_response :success
    assert_select 'tr.record td:first-child.sortable-handle', count: 1, text: ''
  end
end
