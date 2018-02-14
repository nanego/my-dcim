require File.expand_path("../../test_helper", __FILE__)

class RoomsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @room = rooms(:one)
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
    get :overview, params: {gestion_id: 1}
    assert_response :success
    assert_not_nil assigns(:sites)
  end

  test "should get overview with cluster_id" do
    get :overview, params: {cluster_id: 1}
    assert_response :success
    assert_not_nil assigns(:sites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create room" do
    assert_difference('Room.count') do
      post :create, params: {room: { description: @room.description, published: @room.published, name: @room.name }}
    end

    assert_redirected_to rooms_path
  end

  test "should show room" do
    get :show, params:{id: @room}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @room}
    assert_response :success
  end

  test "should update room" do
    patch :update, params: {id: @room, room: { description: @room.description, published: @room.published, name: @room.name }}
    assert_redirected_to rooms_path
  end

  test "should destroy room" do
    assert_difference('Room.count', -1) do
      delete :destroy, params: {id: @room}
    end

    assert_redirected_to rooms_path
  end
end
