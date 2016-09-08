require 'test_helper'

class FramesControllerTest < ActionController::TestCase
  test "should get show" do
    sign_in users(:one)
    get :show
    assert_response :success
  end

end
