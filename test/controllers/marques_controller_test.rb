require 'test_helper'

class MarquesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @marque = marques(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:marques)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create marque" do
    assert_difference('Marque.count') do
      post :create, marque: { description: @marque.description, published: @marque.published, title: @marque.title }
    end

    assert_redirected_to marque_path(assigns(:marque))
  end

  test "should show marque" do
    get :show, id: @marque
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @marque
    assert_response :success
  end

  test "should update marque" do
    patch :update, id: @marque, marque: { description: @marque.description, published: @marque.published, title: @marque.title }
    assert_redirected_to marque_path(assigns(:marque))
  end

  test "should destroy marque" do
    assert_difference('Marque.count', -1) do
      delete :destroy, id: @marque
    end

    assert_redirected_to marques_path
  end
end
