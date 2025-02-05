# frozen_string_literal: true

require 'test_helper'

class DisksControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @disk = disks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:disks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create disk" do
    assert_difference('Disk.count') do
      post :create, params: { disk: { disk_type_id: @disk.disk_type_id, quantity: @disk.quantity, server_id: @disk.server_id } }
    end

    assert_redirected_to server_path(@disk.server)
  end

  test "should show disk" do
    get :show, params: { id: @disk }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @disk }
    assert_response :success
  end

  test "should update disk" do
    patch :update, params: { id: @disk, disk: { disk_type_id: @disk.disk_type_id, quantity: @disk.quantity, server_id: @disk.server_id } }
    assert_redirected_to server_path(@disk.server)
  end

  test "should destroy disk" do
    assert_difference('Disk.count', -1) do
      delete :destroy, params: { id: @disk }
    end

    assert_redirected_to disks_path
  end
end
