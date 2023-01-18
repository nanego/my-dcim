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
end
