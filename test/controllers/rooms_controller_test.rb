# frozen_string_literal: true

require 'test_helper'

class RoomsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:admin)
    @room = rooms(:one)
    @islet = islets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rooms)
  end

  test "should get overview" do
    get :overview
    assert_response :success
    assert_not_nil assigns(:sites)
  end

  test "should get overview with gestion_id" do
    get :overview, params: { gestion_id: 1 }
    assert_response :success
    assert_not_nil assigns(:sites)
  end

  test "should get overview with cluster_id" do
    get :overview, params: { cluster_id: 1 }
    assert_response :success
    assert_not_nil assigns(:sites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create room" do
    @room = rooms(:two)

    assert_difference('Room.count') do
      post :create, params: { room: { description: @room.description, name: @room.name, site_id: @room.site_id } }
    end

    assert_redirected_to room_path(assigns(:room))
  end

  test "should show room" do
    get :show, params: { id: @room }
    assert_response :success
    assert_not_nil assigns(:room)
  end

  test "should show specific islet" do
    get :show, params: { id: @room, islet: 'Islet1' }
    assert_response :success
    assert_not_nil assigns(:room)
    assert_not_nil assigns(:islet)
  end

  test "should get edit" do
    get :edit, params: { id: @room }
    assert_response :success
  end

  test "should destroy room" do
    @room = rooms(:two)

    assert_difference('Room.count', -1) do
      delete :destroy, params: { id: @room }
    end

    assert_redirected_to rooms_path
  end

  test "should not destroy room that have islets" do
    assert_difference('Room.count', 0) do
      delete :destroy, params: { id: @room }
    end

    assert_redirected_to rooms_path
  end
end
