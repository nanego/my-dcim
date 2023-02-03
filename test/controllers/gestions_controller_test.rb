require File.expand_path("../../test_helper", __FILE__)

class GestionsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @gestion = gestions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gestions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gestion" do
    assert_difference('Gestion.count') do
      post :create, params:{ gestion: { description: @gestion.description, name: @gestion.name }}
    end

    assert_redirected_to gestion_path(assigns(:gestion))
  end

  test "should show gestion" do
    get :show, params: {id: @gestion}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @gestion}
    assert_response :success
  end

  test "should update gestion" do
    patch :update, params: {id: @gestion, gestion: { description: @gestion.description, name: @gestion.name }}
    assert_redirected_to gestion_path(assigns(:gestion))
  end

  test "should destroy gestion" do
    @gestion = Gestion.create
    
    assert_difference('Gestion.count', -1) do
      delete :destroy, params: {id: @gestion}
    end
  end

  test "should not destroy gestion it has many servers Server n°1 & 2" do
    assert_difference('Gestion.count', 0) do
      delete :destroy, params: {id: @gestion}
    end

    assert_redirected_to gestions_path
  end
end
