# frozen_string_literal: true

require File.expand_path("../test_helper", __dir__)

class ManagersControllerTest < ActionController::TestCase
  setup do
    sign_in users(:admin)
    @manager = managers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:managers)
  end

  test "should show manager" do
    get :show, params: { id: @manager }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @manager }
    assert_response :success
  end

  test "should update manager" do
    patch :update, params: { id: @manager, manager: { description: @manager.description, name: @manager.name } }
    assert_redirected_to manager_path(assigns(:manager))
  end

  test "should destroy manager" do
    @manager = Manager.create

    assert_difference("Manager.count", -1) do
      delete :destroy, params: { id: @manager, confirm: true }
    end
  end

  test "should not destroy manager it has many servers Server n°1 & 2" do
    assert_difference("Manager.count", 0) do
      delete :destroy, params: { id: @manager, confirm: true }
    end

    assert_redirected_to managers_path
  end
end
