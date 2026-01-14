# frozen_string_literal: true

require File.expand_path("../test_helper", __dir__)

class ManufacturersControllerTest < ActionController::TestCase
  setup do
    sign_in users(:admin)
    @manufacturer = manufacturers(:fortinet)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manufacturers)
  end

  test "should show manufacturer" do
    get :show, params: { id: @manufacturer }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @manufacturer }
    assert_response :success
  end

  test "should update manufacturer" do
    patch :update, params: { id: @manufacturer, manufacturer: { description: @manufacturer.description, name: @manufacturer.name } }
    assert_redirected_to manufacturer_path(assigns(:manufacturer))
  end

  test "should destroy manufacturer" do
    @manufacturer = Manufacturer.create

    assert_difference("Manufacturer.count", -1) do
      delete :destroy, params: { id: @manufacturer, confirm: true }
    end

    assert_redirected_to manufacturers_path
  end

  test "should not destroy manufacturer that have modeles" do
    assert_difference("Manufacturer.count", 0) do
      delete :destroy, params: { id: @manufacturer, confirm: true }
    end

    assert_redirected_to manufacturers_path
  end
end
