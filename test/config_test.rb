# frozen_string_literal: true

require "test_helper"

class ConfigTest < Minitest::Test
  def test_sortable_activation
    refute ModelsController.active_scaffold_config.actions.include?(:sortable)
    assert AutoModelsController.active_scaffold_config.actions.include?(:sortable)
    assert SortableModelsController.active_scaffold_config.actions.include?(:sortable)
  end

  def test_position_column
    assert_equal :position, AutoModelsController.active_scaffold_config.sortable.column.name
    assert_equal :name, SortableModelsController.active_scaffold_config.sortable.column.name
  end

  def test_position_column_is_hidden_from_actions
    config = AutoModelsController.active_scaffold_config

    %i[list update create show search subform].each do |action|
      refute config.public_send(action).columns.include?(:position), action
    end
    assert_equal :hidden, config.columns[:position].form_ui
  end

  def test_manually_selected_column_is_hidden
    config = SortableModelsController.active_scaffold_config

    %i[list update create show].each do |action|
      refute config.public_send(action).columns.include?(:name), action
    end
  end

  def test_sorting_configuration
    regular = ModelsController.active_scaffold_config
    automatic = AutoModelsController.active_scaffold_config
    manual = SortableModelsController.active_scaffold_config

    assert_equal ['"models"."id" ASC'], regular.list.sorting.clause
    assert regular.columns[:name].sortable?
    assert regular.columns[:position].sortable?

    assert_equal ['"models"."position" ASC'], automatic.list.sorting.clause
    refute automatic.columns[:name].sortable?

    assert_equal ['"models"."name" ASC'], manual.list.sorting.clause
    refute manual.columns[:position].sortable?
  end

  def test_sortable_lists_disable_pagination
    assert ModelsController.active_scaffold_config.list.pagination
    refute AutoModelsController.active_scaffold_config.list.pagination
    refute SortableModelsController.active_scaffold_config.list.pagination
  end

  def test_sortable_controllers_register_the_plugin_view_path
    plugin_path = File.join(
      ActiveScaffold::Config::Sortable.plugin_directory,
      "frontends/default"
    )

    refute ModelsController.view_paths.map(&:to_s).include?(plugin_path)
    assert AutoModelsController.view_paths.map(&:to_s).include?(plugin_path)
    assert SortableModelsController.view_paths.map(&:to_s).include?(plugin_path)
  end
end
