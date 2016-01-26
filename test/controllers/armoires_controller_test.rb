require 'test_helper'

class ArmoiresControllerTest < ActionController::TestCase
  setup do
    @armoire = armoires(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:armoires)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create armoire" do
    assert_difference('Armoire.count') do
      post :create, armoire: { description: @armoire.description, published: @armoire.published, title: @armoire.title }
    end

    assert_redirected_to armoire_path(assigns(:armoire))
  end

  test "should show armoire" do
    get :show, id: @armoire
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @armoire
    assert_response :success
  end

  test "should update armoire" do
    patch :update, id: @armoire, armoire: { description: @armoire.description, published: @armoire.published, title: @armoire.title }
    assert_redirected_to armoire_path(assigns(:armoire))
  end

  test "should destroy armoire" do
    assert_difference('Armoire.count', -1) do
      delete :destroy, id: @armoire
    end

    assert_redirected_to armoires_path
  end
end
