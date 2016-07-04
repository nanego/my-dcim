require 'test_helper'

class ServerStatesControllerTest < ActionController::TestCase
  setup do
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
      post :create, server_state: { title: @server_state.title }
    end

    assert_redirected_to server_state_path(assigns(:server_state))
  end

  test "should show server_state" do
    get :show, id: @server_state
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @server_state
    assert_response :success
  end

  test "should update server_state" do
    patch :update, id: @server_state, server_state: { title: @server_state.title }
    assert_redirected_to server_state_path(assigns(:server_state))
  end

  test "should destroy server_state" do
    assert_difference('ServerState.count', -1) do
      delete :destroy, id: @server_state
    end

    assert_redirected_to server_states_path
  end
end
