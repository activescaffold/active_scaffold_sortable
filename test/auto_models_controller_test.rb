require 'test_helper.rb'

class AutoModelsControllerTest < ActionController::TestCase
  @@sortable_regexp = Regexp.new('Sortable.create\("as_auto_models-tbody", \{format:/\^\[\^_-\]\(\?:\[A-Za-z0-9_-\]\*\)-\(\.\*\)-row\$/, onUpdate:function\(\)\{new Ajax.Request\(\'/auto_models/reorder\', \{asynchronous:true, evalScripts:true, parameters:Sortable.serialize\("as_auto_models-tbody"\) \+ \'&controller=\' \+ encodeURIComponent\(\'auto_models\'\)\}\)\}, tag:\'tr\'\}\)')
  setup { AutoModel.create :name => 'test', :position => 1 }

  context "reordering" do
    setup do
      updates = sequence(:updates)
      AutoModel.expects(:update_all).with({:position => 1}, 'id' => '2').in_sequence(updates)
      AutoModel.expects(:update_all).with({:position => 2}, 'id' => '1').in_sequence(updates)
      xhr :post, :reorder, :'as_auto_models-tbody' => ['2', '1']
    end
    should_respond_with :success
    should_render_template :reorder
    should "update stripe" do
      assert_equal 'ActiveScaffold.stripe(\'as_auto_models-tbody\');', @response.body
    end
  end

  context "listing" do
    setup { get :index }
    should "render record with sortable class" do
      assert_select '.records tr.record.sortable'
    end
    should "render sortable script" do
      assert_select 'script[type=text/javascript]', @@sortable_regexp
    end
  end

  context "creating" do
    setup { xhr :post, :create, :record => {:name => 'test2', :position => 2} }
    should_respond_with :success
    should "insert at top" do
      assert_match "$(\"as_auto_models-tbody\").insert(\"as_auto_models-list-#{assigns(:record).id}-row\");", @response.body
    end
    should "update stripe" do
      assert_match 'ActiveScaffold.stripe(\'as_auto_models-tbody\');', @response.body
    end
    should "update sortable" do
      assert_match @@sortable_regexp, @response.body
    end
  end

  context "updating" do
    setup { xhr :put, :update, :id => 1, :record => {:name => 'test updated'} }
    should_respond_with :success
    should "update sortable" do
      assert_match @@sortable_regexp, @response.body
    end
  end
end
