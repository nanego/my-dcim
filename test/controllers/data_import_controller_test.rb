require 'test_helper'

class DataImportControllerTest < ActionDispatch::IntegrationTest
  test "should get ansible" do
    get data_import_ansible_url
    assert_response :success
  end

end
