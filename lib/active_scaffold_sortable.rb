require "#{File.dirname(__FILE__)}/active_scaffold_sortable/config/core.rb"
require "#{File.dirname(__FILE__)}/active_scaffold/config/sortable.rb"
require "#{File.dirname(__FILE__)}/active_scaffold/actions/sortable.rb"
require "#{File.dirname(__FILE__)}/active_scaffold/helpers/sortable_helpers.rb"

module ActiveScaffoldSortable
  def self.root
    File.dirname(__FILE__) + "/.."
  end
end

ActiveScaffold::Config::Core.send :include, ActiveScaffoldSortable::Core
ActiveScaffold::Helpers::ViewHelpers.send :include, ActiveScaffoldSortable::ViewHelpers

##
## Run the install assets script, too, just to make sure
## But at least rescue the action in production
##
Rails::Application.initializer("active_scaffold_sortable.install_assets") do
  begin
    ActiveScaffoldAssets.copy_to_public(ActiveScaffoldSortable.root)
  rescue
    raise $! unless Rails.env == 'production'
  end
end unless defined?(ACTIVE_SCAFFOLD_SORTABLE_PLUGIN) && ACTIVE_SCAFFOLD_SORTABLE_PLUGIN == true
