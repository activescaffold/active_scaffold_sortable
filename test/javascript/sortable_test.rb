# frozen_string_literal: true

require 'javascript_test_helper'

class SortableJavascriptTest < ActiveScaffold::TestSupport::Javascript::TestCase
  def test_loads_jquery_ui_and_sortable_adapter
    visit_javascript_fixture

    assert_javascript 'typeof jQuery.fn.sortable === "function"'
    assert_javascript 'typeof ActiveScaffold.sortable === "function"'
    assert_no_javascript_errors
  end

  def test_updates_positions_in_form_sortables
    with_plugin_assets('active_scaffold_sortable') do
      visit_javascript_fixture sortable_fixture

      assert_selector '#sortable-fields.ui-sortable'
      execute_script <<~JS
        var container = jQuery('#sortable-fields');
        container.append(container.find('.sub-form-record').first());
        container.sortable('option', 'update').call(container[0], {}, {});
      JS

      assert_field 'second-position', with: '1', type: :hidden
      assert_field 'first-position', with: '2', type: :hidden
      assert_no_javascript_errors
    end
  end

  private

  def sortable_fixture
    <<~HTML
      <div class="active-scaffold">
        <form class="as_form">
          <div id="sortable-fields" class="sortable-container" data-column="position" data-tag=".sub-form-record">
            <div class="sub-form-record"><input id="first-position" type="hidden" name="record[items][0][position]" value="1"></div>
            <div class="sub-form-record"><input id="second-position" type="hidden" name="record[items][1][position]" value="2"></div>
          </div>
        </form>
      </div>
    HTML
  end

  def with_plugin_assets(*assets)
    original = ActiveScaffold.javascripts.dup
    ActiveScaffold.javascripts.replace(assets)
    yield
  ensure
    ActiveScaffold.javascripts.replace(original)
  end
end
