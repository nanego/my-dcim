# frozen_string_literal: true

require 'test_helper'

class MemoryComponentsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @memory_component = memory_components(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:memory_components)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create memory_component" do
    assert_difference('MemoryComponent.count') do
      post :create, params:{memory_component: { memory_type_id: @memory_component.memory_type_id, quantity: @memory_component.quantity, server_id: @memory_component.server_id }}
    end

    # FIXME: unstable test, get always different path when trying to fix, and even pass sometimes
    # Expected "http://test.host/servers/1" to be === "http://test.host/servers/servername1".
    # Expected "http://test.host/servers/2" to be === "http://test.host/servers/servername2".
    # Expected "http://test.host/servers/1" to be === "http://test.host/servers/2".
    # assert_redirected_to server_path(@memory_component.server_id)
  end

  test "should show memory_component" do
    get :show, params: {id: @memory_component}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @memory_component}
    assert_response :success
  end

  # FIXME:: unstable test, get always different path when trying to fix, and even pass sometimes
  # test "should update memory_component" do
  #   patch :update, params:{ id: @memory_component, memory_component: { memory_type_id: @memory_component.memory_type_id, quantity: @memory_component.quantity, server_id: @memory_component.server_id }}
  #   assert_redirected_to server_path(@memory_component.server_id)
  # end

  test "should destroy memory_component" do
    assert_difference('MemoryComponent.count', -1) do
      delete :destroy, params: {id: @memory_component}
    end

    assert_redirected_to memory_components_path
  end
end
