# frozen_string_literal: true

require 'test_helper'

class ViewTemplatesTest < ActiveSupport::TestCase
  VIEW_PATH = File.expand_path('../app/views', __dir__)
  LOOKUP_CONTEXT = ActionView::LookupContext.new([VIEW_PATH])

  Association = Struct.new(:klass)
  Column = Struct.new(:name, :association)
  Config = Struct.new(:actions)
  Parent = Struct.new(:id)

  class View < ActionView::Base
    attr_reader :render_calls

    def initialize(lookup_context, assigns, controller)
      super
      @render_calls = []
    end

    def render_root(options)
      @render_root = true
      render(options)
    ensure
      @render_root = false
    end

    def render(options = {}, locals = {}, &)
      if @render_root
        @render_root = false
        super
      else
        render_calls << [options, locals]
        ActiveSupport::SafeBuffer.new('rendered-super')
      end
    end

    def active_scaffold_config_for(_model)
      Config.new([:sortable])
    end

    def sub_form_list_id(association:, id:, tab_id:)
      [association, id, tab_id].compact.join('-')
    end

    def generated_id(_record)
      nil
    end
  end

  CompiledView = View.with_empty_template_cache

  def setup
    @column = Column.new(:children, Association.new(Object))
    @parent = Parent.new(37)
  end

  def test_edit_associated_reinitializes_sorting
    view = build_view(column: @column, parent_record: @parent)

    output = view.render_root(
      template: 'active_scaffold_overrides/edit_associated',
      formats: [:js]
    )

    assert_includes output, "ActiveScaffold.update_positions('children-37')"
    assert_includes output, "ActiveScaffold.sortable('children-37')"
    assert_equal [:super], view.render_calls.map(&:first)
  end

  private

  def build_view(column:, parent_record:)
    CompiledView.new(
      LOOKUP_CONTEXT,
      {column: column, parent_record: parent_record},
      nil
    )
  end
end
