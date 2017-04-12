require 'test_helper'

class DiskTypesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @disk_type = disk_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:disk_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create disk_type" do
    assert_difference('DiskType.count') do
      post :create, disk_type: { technology: @disk_type.technology }
    end

    assert_redirected_to disk_type_path(assigns(:disk_type))
  end

  test "should show disk_type" do
    get :show, id: @disk_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @disk_type
    assert_response :success
  end

  test "should update disk_type" do
    patch :update, id: @disk_type, disk_type: { technology: @disk_type.technology }
    assert_redirected_to disk_type_path(assigns(:disk_type))
  end

  test "should destroy disk_type" do
    assert_difference('DiskType.count', -1) do
      delete :destroy, id: @disk_type
    end

    assert_redirected_to disk_types_path
  end
end
