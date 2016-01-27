require 'test_helper'

class ArchitecturesControllerTest < ActionController::TestCase
  setup do
    @architecture = architectures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:architectures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create architecture" do
    assert_difference('Architecture.count') do
      post :create, architecture: { description: @architecture.description, published: @architecture.published, title: @architecture.title }
    end

    assert_redirected_to architecture_path(assigns(:architecture))
  end

  test "should show architecture" do
    get :show, id: @architecture
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @architecture
    assert_response :success
  end

  test "should update architecture" do
    patch :update, id: @architecture, architecture: { description: @architecture.description, published: @architecture.published, title: @architecture.title }
    assert_redirected_to architecture_path(assigns(:architecture))
  end

  test "should destroy architecture" do
    assert_difference('Architecture.count', -1) do
      delete :destroy, id: @architecture
    end

    assert_redirected_to architectures_path
  end
end
