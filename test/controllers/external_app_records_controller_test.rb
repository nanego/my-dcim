require "test_helper"

class ExternalAppRecordsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get external_app_records_index_url
    assert_response :success
  end
end
