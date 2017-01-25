require 'test_helper'

class MemoryTypesControllerTest < ActionController::TestCase
  setup do
    @memory_type = memory_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:memory_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create memory_type" do
    assert_difference('MemoryType.count') do
      post :create, memory_type: { name: @memory_type.name }
    end

    assert_redirected_to memory_type_path(assigns(:memory_type))
  end

  test "should show memory_type" do
    get :show, id: @memory_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @memory_type
    assert_response :success
  end

  test "should update memory_type" do
    patch :update, id: @memory_type, memory_type: { name: @memory_type.name }
    assert_redirected_to memory_type_path(assigns(:memory_type))
  end

  test "should destroy memory_type" do
    assert_difference('MemoryType.count', -1) do
      delete :destroy, id: @memory_type
    end

    assert_redirected_to memory_types_path
  end
end
