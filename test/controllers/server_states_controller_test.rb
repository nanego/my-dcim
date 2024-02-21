# frozen_string_literal: true

require File.expand_path("../../test_helper", __FILE__)

class ServerStatesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @server_state = server_states(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:server_states)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create server_state" do
    assert_difference('ServerState.count') do
      post :create, params: { server_state: { name: @server_state.name } }
    end

    assert_redirected_to server_state_path(assigns(:server_state))
  end

  test "should show server_state" do
    get :show, params: { id: @server_state }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @server_state }
    assert_response :success
  end

  test "should update server_state" do
    patch :update, params: { id: @server_state, server_state: { name: @server_state.name } }
    assert_redirected_to server_state_path(assigns(:server_state))
  end

  test "should destroy server_state" do
    assert_difference('ServerState.count', -1) do
      delete :destroy, params: { id: @server_state }
    end

    assert_redirected_to server_states_path
  end
end
