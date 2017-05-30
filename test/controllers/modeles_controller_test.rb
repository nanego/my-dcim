require File.expand_path("../../test_helper", __FILE__)

class ModelesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @modele = modeles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:modeles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create modele" do
    assert_difference('Modele.count') do
      post :create, params: {modele: { description: @modele.description, published: @modele.published, name: @modele.name, architecture_id: @modele.architecture_id, category_id: @modele.category_id, u: @modele.u }}
    end
    assert_redirected_to edit_modele_path(assigns(:modele))
  end

  test "should show modele" do
    get :show, params: {id: @modele}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @modele}
    assert_response :success
  end

  test "should update modele" do
    patch :update, params:{id: @modele, modele: { description: @modele.description, published: @modele.published, name: @modele.name, architecture_id: @modele.architecture_id, category_id: @modele.category_id, u: @modele.u }}
    assert_redirected_to edit_modele_path(assigns(:modele))
  end

  test "should destroy modele" do
    assert_difference('Modele.count', -1) do
      delete :destroy, params: {id: @modele}
    end

    assert_redirected_to modeles_path
  end
end
