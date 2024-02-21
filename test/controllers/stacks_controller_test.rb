# frozen_string_literal: true

require File.expand_path("../../test_helper", __FILE__)

class StacksControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @stack = stacks(:red)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stacks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create card type" do
    assert_difference('Stack.count') do
      post :create, params: { stack: {
        name: @stack.name, color: @stack.color
      } }
    end

    assert_redirected_to stacks_path
  end

  test "should show card type" do
    get :show, params: { id: @stack }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @stack }
    assert_response :success
  end

  test "should update stack" do
    patch :update, params: {
      id: @stack,
      stack: { name: @stack.name, color: @stack.color }
    }

    assert_redirected_to stacks_path
  end

  test "should destroy stack" do
    @stack = Stack.create

    assert_difference('Stack.count', -1) do
      delete :destroy, params: { id: @stack }
    end

    assert_redirected_to stacks_path
  end

  test "should not destroy stack that have servers" do
    assert_difference('Stack.count', 0) do
      delete :destroy, params: { id: @stack }
    end

    assert_redirected_to stacks_path
  end
end
