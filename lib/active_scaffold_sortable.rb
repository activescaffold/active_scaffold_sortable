# frozen_string_literal: true

require 'active_scaffold_sortable/engine'
require 'active_scaffold_sortable/extensions'

module ActiveScaffoldSortable
  def self.root
    "#{File.dirname(__FILE__)}/.."
  end
  autoload :Core, 'active_scaffold_sortable/core.rb'
  autoload :ViewHelpers, 'active_scaffold_sortable/view_helpers.rb'
  autoload :AttributeParams, 'active_scaffold_sortable/attribute_params.rb'
end
ActiveScaffold.set_element_tag(:sortable_container, :div)
ActiveScaffold.stylesheets << 'active_scaffold_sortable'
ActiveScaffold.javascripts << 'active_scaffold_sortable'
