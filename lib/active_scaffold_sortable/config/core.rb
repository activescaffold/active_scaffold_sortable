# Need to open the AS module carefully due to Rails 2.3 lazy loading
ActiveScaffold::Config::Core.class_eval do
  ActionDispatch::Routing::ACTIVE_SCAFFOLD_CORE_ROUTING[:collection][:reorder] = :post
end