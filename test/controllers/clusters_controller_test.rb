# frozen_string_literal: true

require File.expand_path("../../test_helper", __FILE__)

class ClustersControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @cluster = clusters(:cloud_c1)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clusters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cluster" do
    assert_difference("Cluster.count") do
      post :create, params: { cluster: { name: @cluster.name } }
    end

    assert_redirected_to cluster_path(assigns(:cluster))
  end

  test "should show cluster" do
    get :show, params: { id: @cluster }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @cluster }
    assert_response :success
  end

  test "should update cluster" do
    patch :update, params: { id: @cluster, cluster: { name: @cluster.name } }
    assert_redirected_to cluster_path(assigns(:cluster))
  end

  test "should destroy cluster" do
    @cluster = Cluster.create

    assert_difference("Cluster.count", -1) do
      delete :destroy, params: { id: @cluster }
    end

    assert_redirected_to clusters_path
  end

  test "should not destroy cluster that have servers" do
    assert_difference("Cluster.count", 0) do
      delete :destroy, params: { id: @cluster }
    end

    assert_redirected_to clusters_path
  end
end
