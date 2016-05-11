require 'test_helper'

class LocalisationsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @localisation = localisations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:localisations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create localisation" do
    assert_difference('Localisation.count') do
      post :create, localisation: { description: @localisation.description, published: @localisation.published, title: @localisation.title }
    end

    assert_redirected_to localisation_path(assigns(:localisation))
  end

  test "should show localisation" do
    get :show, id: @localisation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @localisation
    assert_response :success
  end

  test "should update localisation" do
    patch :update, id: @localisation, localisation: { description: @localisation.description, published: @localisation.published, title: @localisation.title }
    assert_redirected_to localisation_path(assigns(:localisation))
  end

  test "should destroy localisation" do
    assert_difference('Localisation.count', -1) do
      delete :destroy, id: @localisation
    end

    assert_redirected_to localisations_path
  end
end
