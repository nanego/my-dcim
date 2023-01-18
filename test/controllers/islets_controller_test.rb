# frozen_string_literal: true

require File.expand_path("../../test_helper", __FILE__)

class IsletsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @islet = islets(:one)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
    post :create, params: {islet: {name:'test'}}
    assert_redirected_to islets_path
  end

  test "should get edit" do
    get :edit, params: {id: @islet}
    assert_response :success
  end

  test "should update" do
    patch :update, params: {id: @islet, islet: {name:"updated_name"}}
    assert_redirected_to islets_path
  end

  test "should get destroy" do
    delete :destroy, params: {id: @islet}
    assert_redirected_to islets_url
  end

  test "should destroy islet" do
    @islet = Islet.create
    
    assert_difference('Islet.count', -1) do
      delete :destroy, params: {id: @islet}
    end

    assert_redirected_to islets_path
  end

  test "should not destroy islet that have bays" do
    assert_difference('Islet.count', 0) do
      delete :destroy, params: {id: @islet}
    end

    assert_redirected_to islets_path
  end
end
