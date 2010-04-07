module Sortable
  def self.plugin_name
    @plugin_name ||= (/.+vendor\/plugins\/(.+)\/lib/.match(File.expand_path(__FILE__)))[1]
  end
end
ActiveScaffold::Config::Core.send :include, Sortable::Core
ActiveScaffold::Helpers::ViewHelpers.send :include, Sortable::ViewHelpers
ActionController::Resources::Resource::ACTIVE_SCAFFOLD_ROUTING[:collection][:reorder] = :post
