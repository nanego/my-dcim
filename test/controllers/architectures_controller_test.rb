require File.expand_path("../../test_helper", __FILE__)

class ArchitecturesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
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
      post :create, params: {architecture: { description: @architecture.description, published: @architecture.published, name: @architecture.name }}
    end

    assert_redirected_to architecture_path(assigns(:architecture))
  end

  test "should show architecture" do
    get :show, params: {id: @architecture}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @architecture}
    assert_response :success
  end

  test "should update architecture" do
    patch :update, params: {id: @architecture, architecture: { description: @architecture.description, published: @architecture.published, name: @architecture.name }}
    assert_redirected_to architecture_path(assigns(:architecture))
  end

  test "should destroy architecture" do
    assert_difference('Architecture.count', -1) do
      delete :destroy, params: {id: @architecture}
    end

    assert_redirected_to architectures_path
  end
end
