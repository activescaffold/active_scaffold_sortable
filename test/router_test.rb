# frozen_string_literal: true

require "test_helper"

class RouterTest < ActionDispatch::IntegrationTest
  test "routes reorder requests" do
    assert_routing(
      { method: :post, path: "/sortable_models/reorder" },
      { controller: "sortable_models", action: "reorder" }
    )
  end
end
