# frozen_string_literal: true

require "test_helper"

class RoomsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:admin)
    @room = rooms(:one)
    @islet = islets(:one)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create room" do
    @room = rooms(:two)

    assert_difference("Room.count") do
      post :create, params: { room: { description: @room.description, name: @room.name, site_id: @room.site_id } }
    end

    assert_redirected_to room_path(assigns(:room))
  end

  test "should get edit" do
    get :edit, params: { id: @room }
    assert_response :success
  end

  test "should destroy room" do
    @room = rooms(:two)

    assert_difference("Room.count", -1) do
      delete :destroy, params: { id: @room, confirm: true }
    end

    assert_redirected_to rooms_path
  end

  test "should not destroy room that have islets" do
    assert_difference("Room.count", 0) do
      delete :destroy, params: { id: @room, confirm: true }
    end

    assert_redirected_to rooms_path
  end
end
