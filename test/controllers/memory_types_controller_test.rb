# frozen_string_literal: true

require 'test_helper'

class MemoryTypesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @memory_type = memory_types(:sixteen_gb)
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
      post :create, params: {memory_type: { unit: "Mb", quantity: 189 }}
    end

    assert_redirected_to memory_type_path(assigns(:memory_type))
  end

  test "should show memory_type" do
    get :show, params: {id: @memory_type}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @memory_type}
    assert_response :success
  end

  test "should update memory_type" do
    patch :update, params: {id: @memory_type, memory_type: { unit: @memory_type.unit }}
    assert_redirected_to memory_type_path(assigns(:memory_type))
  end

  test "should destroy memory_type" do
    @memory_type = MemoryType.create
    
    assert_difference('MemoryType.count', -1) do
      delete :destroy, params: {id: @memory_type}
    end

    assert_redirected_to memory_types_path
  end

  test "should not destroy memory_type that have memory_components" do
    assert_difference('MemoryType.count', 0) do
      delete :destroy, params: {id: @memory_type}
    end

    assert_redirected_to memory_types_path
  end
end
