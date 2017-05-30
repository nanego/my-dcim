require File.expand_path("../../test_helper", __FILE__)

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
      post :create, params: {marque: { description: @marque.description, published: @marque.published, name: @marque.name }}
    end

    assert_redirected_to marque_path(assigns(:marque))
  end

  test "should show marque" do
    get :show, params: {id: @marque}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @marque}
    assert_response :success
  end

  test "should update marque" do
    patch :update, params: {id: @marque, marque: { description: @marque.description, published: @marque.published, name: @marque.name }}
    assert_redirected_to marque_path(assigns(:marque))
  end

  test "should destroy marque" do
    assert_difference('Marque.count', -1) do
      delete :destroy, params: {id: @marque}
    end

    assert_redirected_to marques_path
  end
end
