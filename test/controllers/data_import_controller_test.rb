# frozen_string_literal: true

require "test_helper"

class DataImportControllerTest < ActionController::TestCase
  setup do
    sign_in users(:admin)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get ansible" do
    post :ansible
    assert_response :success
  end
end
