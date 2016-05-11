require 'test_helper'

class DomainesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @domaine = domaines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:domaines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create domaine" do
    assert_difference('Domaine.count') do
      post :create, domaine: { description: @domaine.description, published: @domaine.published, title: @domaine.title }
    end

    assert_redirected_to domaine_path(assigns(:domaine))
  end

  test "should show domaine" do
    get :show, id: @domaine
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @domaine
    assert_response :success
  end

  test "should update domaine" do
    patch :update, id: @domaine, domaine: { description: @domaine.description, published: @domaine.published, title: @domaine.title }
    assert_redirected_to domaine_path(assigns(:domaine))
  end

  test "should destroy domaine" do
    assert_difference('Domaine.count', -1) do
      delete :destroy, id: @domaine
    end

    assert_redirected_to domaines_path
  end
end
