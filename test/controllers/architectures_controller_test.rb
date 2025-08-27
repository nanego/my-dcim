# frozen_string_literal: true

require File.expand_path("../../test_helper", __FILE__)

class ArchitecturesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:admin)
    @architecture = architectures(:rackable)
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
    assert_difference("Architecture.count") do
      post :create, params: { architecture: { description: @architecture.description, name: @architecture.name } }
    end

    assert_redirected_to architecture_path(assigns(:architecture))
  end

  test "should show architecture" do
    get :show, params: { id: @architecture }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @architecture }
    assert_response :success
  end

  test "should update architecture" do
    patch :update, params: { id: @architecture, architecture: { description: @architecture.description, name: @architecture.name } }
    assert_redirected_to architecture_path(assigns(:architecture))
  end

  test "should destroy architecture" do
    @architecture = Architecture.create

    assert_difference("Architecture.count", -1) do
      delete :destroy, params: { id: @architecture }
    end

    assert_redirected_to architectures_path
  end

  test "should not destroy architecture that have modeles" do
    assert_difference("Architecture.count", 0) do
      delete :destroy, params: { id: @architecture }
    end

    assert_redirected_to architectures_path
  end
end
