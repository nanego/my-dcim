require 'test_helper'

class GestionsControllerTest < ActionController::TestCase
  setup do
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
      post :create, gestion: { description: @gestion.description, published: @gestion.published, title: @gestion.title }
    end

    assert_redirected_to gestion_path(assigns(:gestion))
  end

  test "should show gestion" do
    get :show, id: @gestion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gestion
    assert_response :success
  end

  test "should update gestion" do
    patch :update, id: @gestion, gestion: { description: @gestion.description, published: @gestion.published, title: @gestion.title }
    assert_redirected_to gestion_path(assigns(:gestion))
  end

  test "should destroy gestion" do
    assert_difference('Gestion.count', -1) do
      delete :destroy, id: @gestion
    end

    assert_redirected_to gestions_path
  end
end
