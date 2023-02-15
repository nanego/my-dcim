require 'test_helper'

class MaintainersControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @maintainer = maintainers(:dell)
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
      post :create, params:{maintainer: { name: @maintainer.name }}
    end

    assert_redirected_to maintainer_path(assigns(:maintainer))
  end

  test "should show maintainer" do
    get :show, params: {id: @maintainer}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @maintainer}
    assert_response :success
  end

  test "should update maintainer" do
    patch :update, params: {id: @maintainer, maintainer: { name: @maintainer.name }}
    assert_redirected_to maintainer_path(assigns(:maintainer))
  end

  test "should destroy maintainer" do
    @maintainer = Maintainer.create

    assert_difference('Maintainer.count', -1) do
      delete :destroy, params: {id: @maintainer}
    end

    assert_redirected_to maintainers_path
  end

  test "should not destroy maintainer that have maintenance_contracts" do
    assert_difference('Maintainer.count', 0) do
      delete :destroy, params: {id: @maintainer}
    end

    assert_redirected_to maintainers_path
  end
end
