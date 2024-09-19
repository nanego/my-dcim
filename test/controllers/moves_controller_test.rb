# frozen_string_literal: true

require 'test_helper'

class MovesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @move = moves(:one)

    @test_params = {
      moveable_type: "Server",
      moveable_id: servers(:one).id,
      frame_id: frames(:one).id,
      prev_frame_id: frames(:two).id,
      position: 40
    }
  end

  test "should get index" do
    get moves_url
    assert_response :success
  end

  test "should get new" do
    get new_move_url
    assert_response :success
  end

  test "should create move" do
    assert_difference('Move.count') do
      post moves_url, params: { move: @test_params }
    end

    assert_redirected_to edit_move_url(Move.last)
  end

  test "should show move" do
    get move_url(@move)
    assert_response :success
  end

  test "should get edit" do
    get edit_move_url(@move)
    assert_response :success
  end

  test "should update move" do
    patch move_url(@move), params: { move: @test_params }
    assert_redirected_to edit_move_url(@move)
  end

  test "should destroy move" do
    assert_difference('Move.count', -1) do
      delete move_url(@move)
    end

    assert_redirected_to moves_url
  end

  test "should execute move" do
    get execute_move_url(@move)
    assert_response :redirect
    # assert_not_nil assigns(:moves)
  end
end
