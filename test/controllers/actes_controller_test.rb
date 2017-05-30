require File.expand_path("../../test_helper", __FILE__)
# require 'test_helper'

class ActesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @acte = actes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:actes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create acte" do
    assert_difference('Acte.count') do
      post :create, params: {acte: { description: @acte.description, published: @acte.published, name: @acte.name }}
    end

    assert_redirected_to acte_path(assigns(:acte))
  end

  test "should show acte" do
    get :show, params: { id: @acte }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @acte }
    assert_response :success
  end

  test "should update acte" do
    patch :update, params: { id: @acte, acte: { description: @acte.description, published: @acte.published, name: @acte.name } }
    assert_redirected_to acte_path(assigns(:acte))
  end

  test "should destroy acte" do
    assert_difference('Acte.count', -1) do
      delete :destroy, params: { id: @acte }
    end

    assert_redirected_to actes_path
  end
end
