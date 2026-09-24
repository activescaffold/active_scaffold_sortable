# frozen_string_literal: true

require "test_helper"

class TreeModelsControllerTest < ActionController::TestCase
  setup do
    Model.delete_all
  end

  test "reorders Ancestry root nodes" do
    @controller = AncestryModelsController.new
    first = AncestryModel.create!(name: "first", position: 1)
    second = AncestryModel.create!(name: "second", position: 2)

    post :reorder,
         params: { "as_ancestry_models-tbody" => [second.id, first.id] },
         xhr: true

    assert_response :success
    assert_equal 2, first.reload.position
    assert_equal 1, second.reload.position
  end

  test "reorders Ancestry children without changing their parent" do
    @controller = AncestryModelsController.new
    parent = AncestryModel.create!(name: "parent", position: 1)
    first = AncestryModel.create!(name: "first", position: 1, parent: parent)
    second = AncestryModel.create!(name: "second", position: 2, parent: parent)

    post :reorder,
         params: { "as_ancestry_models-tbody" => [second.id, first.id] },
         xhr: true

    assert_response :success
    assert_equal [parent.id, 2], [first.reload.parent_id, first.position]
    assert_equal [parent.id, 1], [second.reload.parent_id, second.position]
  end

  test "auto-enables and reorders nested-set API models" do
    @controller = NestedSetModelsController.new
    first = NestedSetModel.create!(name: "first", position: 1)
    second = NestedSetModel.create!(name: "second", position: 2)
    third = NestedSetModel.create!(name: "third", position: 3)

    assert NestedSetModelsController.active_scaffold_config.actions.include?(:sortable)

    post :reorder,
         params: { "as_nested_set_models-tbody" => [third.id, first.id, second.id] },
         xhr: true

    assert_response :success
    assert_equal [third.id, first.id, second.id],
                 NestedSetModel.order(:position).pluck(:id)
  end

  test "reorders nested-set children without changing their parent" do
    @controller = NestedSetModelsController.new
    parent = NestedSetModel.create!(name: "parent", position: 1)
    first = NestedSetModel.create!(name: "first", position: 1, parent_id: parent.id)
    second = NestedSetModel.create!(name: "second", position: 2, parent_id: parent.id)

    post :reorder,
         params: { "as_nested_set_models-tbody" => [second.id, first.id] },
         xhr: true

    assert_response :success
    assert_equal [parent.id, 2], [first.reload.parent_id, first.position]
    assert_equal [parent.id, 1], [second.reload.parent_id, second.position]
  end
end
