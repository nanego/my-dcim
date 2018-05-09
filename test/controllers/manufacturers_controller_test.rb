require File.expand_path("../../test_helper", __FILE__)

class ManufacturersControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @manufacturer = manufacturers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manufacturers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manufacturer" do
    assert_difference('Manufacturer.count') do
      post :create, params: {manufacturer: { description: @manufacturer.description, published: @manufacturer.published, name: @manufacturer.name }}
    end

    assert_redirected_to manufacturer_path(assigns(:manufacturer))
  end

  test "should show manufacturer" do
    get :show, params: {id: @manufacturer}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @manufacturer}
    assert_response :success
  end

  test "should update manufacturer" do
    patch :update, params: {id: @manufacturer, manufacturer: { description: @manufacturer.description, published: @manufacturer.published, name: @manufacturer.name }}
    assert_redirected_to manufacturer_path(assigns(:manufacturer))
  end

  test "should destroy manufacturer" do
    assert_difference('Manufacturer.count', -1) do
      delete :destroy, params: {id: @manufacturer}
    end

    assert_redirected_to manufacturers_path
  end
end
