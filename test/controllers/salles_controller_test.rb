require 'test_helper'

class SallesControllerTest < ActionController::TestCase
  setup do
    @salle = salles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:salles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create salle" do
    assert_difference('Salle.count') do
      post :create, salle: { description: @salle.description, published: @salle.published, title: @salle.title }
    end

    assert_redirected_to salle_path(assigns(:salle))
  end

  test "should show salle" do
    get :show, id: @salle
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @salle
    assert_response :success
  end

  test "should update salle" do
    patch :update, id: @salle, salle: { description: @salle.description, published: @salle.published, title: @salle.title }
    assert_redirected_to salle_path(assigns(:salle))
  end

  test "should destroy salle" do
    assert_difference('Salle.count', -1) do
      delete :destroy, id: @salle
    end

    assert_redirected_to salles_path
  end
end
