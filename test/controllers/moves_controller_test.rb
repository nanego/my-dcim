require 'test_helper'

class MovesControllerTest < ActionDispatch::IntegrationTest

  def test_params
    { :moveable_type => 'Server',
                  :moveable_id => servers(:one).id,
                  :frame_id => frames(:one).id,
                  :position => 40 }
  end

  setup do
    sign_in users(:one)
    @move = moves(:one)
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
      post moves_url, params: { move: test_params }
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
    patch move_url(@move), params: { move: test_params }
    assert_redirected_to edit_move_url(@move)
  end

  test "should destroy move" do
    assert_difference('Move.count', -1) do
      delete move_url(@move)
    end

    assert_redirected_to moves_url
  end
end
