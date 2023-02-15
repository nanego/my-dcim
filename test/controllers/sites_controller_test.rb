require 'test_helper'

class SitesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @site = sites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site" do
    assert_difference('Site.count') do
      post :create, params: {site: { name: @site.name }}
    end

    assert_redirected_to sites_path
  end

  test "should show site" do
    get :show, params: {id: @site}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @site}
    assert_response :success
  end

  test "should update site" do
    patch :update, params: { id: @site, site: { name: @site.name } }
    assert_redirected_to sites_path
  end

  test "should destroy site" do
    @site = Site.create

    assert_difference('Site.count', -1) do
      delete :destroy, params: {id: @site}
    end
  end

  test "should not destroy the site it has many rooms Room n°1 & 2" do
    assert_difference('Site.count', 0) do
      delete :destroy, params: {id: @site}
    end

    assert_redirected_to sites_path
  end
end
