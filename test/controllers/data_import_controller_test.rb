# frozen_string_literal: true

require "test_helper"

class DataImportControllerTest < ActionController::TestCase
  setup do
    sign_in users(:admin)
  end

  test "should get ansible" do
    get :index
    assert_response :success
  end
end
