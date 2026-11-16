# frozen_string_literal: true

require 'test_helper'

class ConfigTest < ActiveSupport::TestCase
  class FakeColumn
    attr_accessor :css_class, :form_ui, :label, :name, :sort, :weight

    def initialize(name)
      @name = name
    end
  end

  class FakeColumns
    attr_reader :excluded

    def initialize(*names)
      @columns = names.index_with { |name| FakeColumn.new(name) }
      @excluded = []
    end

    def [](name)
      @columns[name.to_sym]
    end

    def add(name)
      @columns[name] ||= FakeColumn.new(name)
    end

    def exclude(name)
      excluded << name
    end
  end

  class FakeListColumns
    attr_reader :values

    delegate :include?, to: :values

    def initialize(values)
      @values = values
    end

    def to_a
      values
    end

    def add(name)
      values << name unless include? name
    end
  end

  FakeList = Struct.new(:columns)
  FakeCore = Struct.new(:model, :columns, :actions, :list, :model_id)

  PositionModel = Class.new do
    def acts_as_list_class; end

    def position_column
      :position
    end
  end

  MissingPositionModel = Class.new do
    def acts_as_list_class; end

    def position_column
      :missing_position
    end
  end

  MissingNestedSetModel = Class.new do
    def nested_set_scope; end

    def left_column_name
      :missing_left
    end
  end

  def test_sortable_activation
    assert_not ModelsController.active_scaffold_config.actions.include?(:sortable)
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
      assert_not config.public_send(action).columns.include?(:position), action
    end
    assert_equal :hidden, config.columns[:position].form_ui
  end

  def test_manually_selected_column_is_hidden
    config = SortableModelsController.active_scaffold_config

    %i[list update create show].each do |action|
      assert_not config.public_send(action).columns.include?(:name), action
    end
  end

  def test_sorting_configuration
    regular = ModelsController.active_scaffold_config
    automatic = AutoModelsController.active_scaffold_config
    manual = SortableModelsController.active_scaffold_config

    assert_equal [{id: 'ASC'}], regular.list.sorting.clause
    assert regular.columns[:name].sortable?
    assert regular.columns[:position].sortable?

    assert_equal [{position: 'ASC'}], automatic.list.sorting.clause
    assert_not automatic.columns[:name].sortable?

    assert_equal [{name: 'ASC'}], manual.list.sorting.clause
    assert_not manual.columns[:position].sortable?
  end

  def test_sortable_lists_disable_pagination
    assert ModelsController.active_scaffold_config.list.pagination
    assert_not AutoModelsController.active_scaffold_config.list.pagination
    assert_not SortableModelsController.active_scaffold_config.list.pagination
  end

  def test_sortable_controllers_register_the_plugin_view_path
    plugin_path = File.join(
      ActiveScaffold::Config::Sortable.plugin_directory,
      'frontends/default'
    )

    assert_not ModelsController.view_paths.map(&:to_s).include?(plugin_path)
    assert AutoModelsController.view_paths.map(&:to_s).include?(plugin_path)
    assert SortableModelsController.view_paths.map(&:to_s).include?(plugin_path)
  end

  def test_missing_acts_as_list_position_column_is_rejected
    error = assert_raises(RuntimeError) do
      ActiveScaffold::Config::Sortable.new(fake_core(MissingPositionModel, :name))
    end

    assert_includes error.message, "Missing sortable attribute 'missing_position'"
  end

  def test_missing_nested_set_left_column_is_rejected
    error = assert_raises(RuntimeError) do
      ActiveScaffold::Config::Sortable.new(fake_core(MissingNestedSetModel, :name))
    end

    assert_includes error.message, "Missing sortable attribute 'missing_left'"
  end

  def test_handle_column_can_be_added_last
    core = fake_core(PositionModel, :position, :name)
    config = ActiveScaffold::Config::Sortable.new(core)

    config.add_handle_column = :last

    handle = core.columns[:active_scaffold_sortable]
    assert_equal :last, config.add_handle_column
    assert_equal 'td.sortable-handle', config.options[:handle]
    assert_equal :active_scaffold_sortable, core.list.columns.to_a.last
    assert_equal '', handle.label
    assert_not handle.sort
    assert_operator config.column.weight, :>, 0
    assert_includes core.columns.excluded, :active_scaffold_sortable
  end

  def test_handle_column_position_must_be_first_or_last
    config = ActiveScaffold::Config::Sortable.new(fake_core(PositionModel, :position))

    error = assert_raises(ArgumentError) { config.add_handle_column = :middle }

    assert_equal 'Unknown handle column position: middle', error.message
  end

  private

  def fake_core(model, *columns)
    FakeCore.new(
      model,
      FakeColumns.new(*columns),
      [:list],
      FakeList.new(FakeListColumns.new(columns.dup)),
      :fake
    )
  end
end
