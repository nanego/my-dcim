require File.expand_path("../../test_helper", __FILE__)

class DomainesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @domaine = domaines(:switch)
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
      post :create, params:{domaine: { description: @domaine.description, name: @domaine.name }}
    end

    assert_redirected_to domaine_path(assigns(:domaine))
  end

  test "should show domaine" do
    get :show, params: {id: @domaine}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @domaine}
    assert_response :success
  end

  test "should update domaine" do
    patch :update, params: {id: @domaine, domaine: { description: @domaine.description, name: @domaine.name }}
    assert_redirected_to domaine_path(assigns(:domaine))
  end

  test "should destroy domaine" do
    @domaine = Domaine.create
    
    assert_difference('Domaine.count', -1) do
      delete :destroy, params: {id: @domaine}
    end

    assert_redirected_to domaines_path
  end

  test "should not destroy domaine that have modeles" do
    assert_difference('Domaine.count', 0) do
      delete :destroy, params: {id: @domaine}
    end

    assert_redirected_to domaines_path
  end
end
