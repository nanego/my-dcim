require File.expand_path("../../test_helper", __FILE__)

class FramesControllerTest < ActionController::TestCase
  test "should get show" do
    sign_in users(:one)
    get :index
    assert_response :success
  end
end
