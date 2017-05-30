require File.expand_path("../../test_helper", __FILE__)

class CategoriesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @category = categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create category" do
    assert_difference('Category.count') do
      post :create, params:{category: { description: @category.description, published: @category.published, name: @category.name }}
    end

    assert_redirected_to category_path(assigns(:category))
  end

  test "should show category" do
    get :show, params: {id: @category}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @category}
    assert_response :success
  end

  test "should update category" do
    patch :update, params: {id: @category, category: { description: @category.description, published: @category.published, name: @category.name }}
    assert_redirected_to category_path(assigns(:category))
  end

  test "should destroy category" do
    assert_difference('Category.count', -1) do
      delete :destroy, params: {id: @category}
    end

    assert_redirected_to categories_path
  end
end
