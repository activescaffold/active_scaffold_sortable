# frozen_string_literal: true

require "test_helper"

class AttributeParamsTest < Minitest::Test
  Record = Struct.new(:position)
  AssociationConfig = Struct.new(:actions, :sortable)
  SortableConfig = Struct.new(:column)
  ColumnConfig = Struct.new(:name)
  Reflection = Struct.new(:name) do
    def collection?
      true
    end
  end
  FormColumn = Struct.new(:association)

  class Parent
    attr_reader :target

    def association(_name)
      self
    end

    def target=(records)
      @target = records
    end
  end

  class BaseUpdater
    attr_accessor :submitted_records

    def update_column_from_params(*)
      submitted_records
    end
  end

  class Updater < BaseUpdater
    prepend ActiveScaffoldSortable::AttributeParams

    attr_accessor :associated_config

    def active_scaffold_config_for(_klass)
      associated_config
    end
  end

  def test_assigns_missing_subform_positions_and_sorts_the_target
    updater = Updater.new
    records = [Record.new(2), Record.new(nil), Record.new(1)]
    updater.submitted_records = records
    updater.associated_config = AssociationConfig.new(
      [:sortable],
      SortableConfig.new(ColumnConfig.new(:position))
    )
    reflection = Reflection.new(:records)
    reflection.define_singleton_method(:klass) { Record }
    parent = Parent.new

    result = updater.update_column_from_params(
      parent,
      FormColumn.new(reflection),
      :records
    )

    assert_same records, result
    assert_equal [2, 3, 1], records.map(&:position)
    assert_equal [1, 2, 3], parent.target.map(&:position)
  end
end
