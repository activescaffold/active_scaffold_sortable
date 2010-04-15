require 'test_helper.rb'

class ConfigTest < Test::Unit::TestCase
  def test_not_enable_sortable
    assert !ModelsController.active_scaffold_config.actions.include?(:sortable)
  end

  def test_auto_enable_sortable
    assert AutoModelsController.active_scaffold_config.actions.include?(:sortable)
  end

  def test_manual_enable_sortable
    assert SortableModelsController.active_scaffold_config.actions.include?(:sortable)
  end

  def test_position_column
    assert_equal :position, AutoModelsController.active_scaffold_config.sortable.column.name
    assert_equal :name, SortableModelsController.active_scaffold_config.sortable.column.name
  end

  def test_position_column_not_included
    assert !AutoModelsController.active_scaffold_config.list.columns.include?(:position)
    assert !AutoModelsController.active_scaffold_config.update.columns.include?(:position)
    assert !AutoModelsController.active_scaffold_config.create.columns.include?(:position)
    assert !AutoModelsController.active_scaffold_config.show.columns.include?(:position)
    assert !AutoModelsController.active_scaffold_config.subform.columns.include?(:position)
    assert !AutoModelsController.active_scaffold_config.search.columns.include?(:position)

    assert !SortableModelsController.active_scaffold_config.list.columns.include?(:name)
    assert !SortableModelsController.active_scaffold_config.update.columns.include?(:name)
    assert !SortableModelsController.active_scaffold_config.create.columns.include?(:name)
    assert !SortableModelsController.active_scaffold_config.show.columns.include?(:name)
  end

  def test_sorting
    assert_equal('"models"."id" ASC', ModelsController.active_scaffold_config.list.sorting.clause)
    assert ModelsController.active_scaffold_config.columns[:name].sortable?
    assert ModelsController.active_scaffold_config.columns[:position].sortable?

    assert_equal('"models"."position" ASC', AutoModelsController.active_scaffold_config.list.sorting.clause)
    assert !AutoModelsController.active_scaffold_config.columns[:name].sortable?

    assert_equal('"models"."name" ASC', SortableModelsController.active_scaffold_config.list.sorting.clause)
    assert !SortableModelsController.active_scaffold_config.columns[:position].sortable?
  end

  def test_pagination
    assert ModelsController.active_scaffold_config.list.pagination
    assert !AutoModelsController.active_scaffold_config.list.pagination
    assert !SortableModelsController.active_scaffold_config.list.pagination
  end

  def test_active_scaffold_paths
    path = File.join(Rails.root, 'vendor/plugins/active_scaffold_sortable/frontends/default/views')
    assert !ModelsController.active_scaffold_paths.include?(path)
    assert AutoModelsController.active_scaffold_paths.include?(path)
    assert SortableModelsController.active_scaffold_paths.include?(path)
  end
end
