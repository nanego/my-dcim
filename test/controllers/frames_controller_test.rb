# frozen_string_literal: true

require File.expand_path("../../test_helper", __FILE__)

class FramesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @frame = frames(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:frames)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create frame" do
    assert_difference('Frame.count') do
      post :create, params: { frame: { name: "MyFrame5", bay_id: 1 } }
    end

    assert_redirected_to frames_path
  end

  test "should get show" do
    get :show, params: { id: @frame }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @frame }
    assert_response :success
  end

  test "should update frame" do
    patch :update, params: { id: @frame, frame: { name: @frame.name } }
    assert_redirected_to room_path(@frame.room)
  end

  test "should destroy frame" do
    @frame = frames(:two)

    assert_difference('Frame.count', -1) do
      delete :destroy, params: { id: @frame }
    end
  end

  test "should not destroy frame it has many servers Server n°1 & 2 and pdu Pdu n°1" do
    assert_difference('Frame.count', 0) do
      delete :destroy, params: { id: @frame }
    end

    assert_redirected_to frames_path
  end
end
