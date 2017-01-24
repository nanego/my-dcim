require 'test_helper'

class MaintainersControllerTest < ActionController::TestCase
  setup do
    @maintainer = maintainers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:maintainers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create maintainer" do
    assert_difference('Maintainer.count') do
      post :create, maintainer: { name: @maintainer.name }
    end

    assert_redirected_to maintainer_path(assigns(:maintainer))
  end

  test "should show maintainer" do
    get :show, id: @maintainer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @maintainer
    assert_response :success
  end

  test "should update maintainer" do
    patch :update, id: @maintainer, maintainer: { name: @maintainer.name }
    assert_redirected_to maintainer_path(assigns(:maintainer))
  end

  test "should destroy maintainer" do
    assert_difference('Maintainer.count', -1) do
      delete :destroy, id: @maintainer
    end

    assert_redirected_to maintainers_path
  end
end
