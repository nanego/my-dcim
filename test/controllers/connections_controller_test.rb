# frozen_string_literal: true

require File.expand_path("../../test_helper", __FILE__)

class ConnectionsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @connection = connections(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
  end
end
