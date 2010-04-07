require 'test_helper.rb'

class RouterTest < ActionController::TestCase
  should_route :post, "/sortable_models/reorder", :controller => :sortable_models, :action => :reorder
end
