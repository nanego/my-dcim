# frozen_string_literal: true

require File.expand_path("../test_helper", __dir__)

class ClustersControllerTest < ActionController::TestCase
  setup do
    sign_in users(:admin)
    @cluster = clusters(:cloud_c1)
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
      delete :destroy, params: { id: @cluster, confirm: true }
    end

    assert_redirected_to clusters_path
  end

  test "should not destroy cluster that have servers" do
    assert_difference("Cluster.count", 0) do
      delete :destroy, params: { id: @cluster, confirm: true }
    end

    assert_redirected_to clusters_path
  end
end
