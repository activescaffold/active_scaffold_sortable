# frozen_string_literal: true

require "test_helper"

class AutoModelsControllerTest < ActionController::TestCase
  tests AutoModelsController

  setup do
    AutoModel.delete_all
    @first = AutoModel.create!(name: "first", position: 1)
    @second = AutoModel.create!(name: "second", position: 2)
  end

  test "reorders records and renders the reorder response" do
    post :reorder,
         params: { "as_auto_models-tbody" => [@second.id, @first.id] },
         xhr: true

    assert_response :success
    assert_equal 2, @first.reload.position
    assert_equal 1, @second.reload.position
    assert_operator @first.updated_at, :>, @first.created_at
    assert_includes response.body, "ActiveScaffold.stripe('as_auto_models-tbody');"
  end

  test "renders sortable metadata and a row drag handle" do
    get :index

    assert_response :success
    assert_select ".sortable-container[data-reorder-url='/auto_models/reorder']"
    assert_select ".sortable-container[data-column='position']"
    assert_select ".records tr.record.sortable-handle", count: 2
  end

  test "keeps sorting active after creating a record" do
    post :create, params: { record: { name: "third", position: 3 } }, xhr: true

    assert_response :success
    assert_equal 3, AutoModel.count
    assert_includes response.body, "ActiveScaffold.sortable('as_auto_models-tbody');"
  end

  test "keeps sorting active after updating a record" do
    put :update, params: { id: @first.id, record: { name: "updated" } }, xhr: true

    assert_response :success
    assert_equal "updated", @first.reload.name
    assert_includes response.body, "ActiveScaffold.sortable('as_auto_models-tbody');"
  end
end
