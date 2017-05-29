require File.expand_path("../../test_helper", __FILE__)

class ActivitiesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
  end
end
