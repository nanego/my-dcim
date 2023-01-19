# frozen_string_literal: true

require 'test_helper'

class MaintenanceContractsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @maintenance_contract = maintenance_contracts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:maintenance_contracts)
  end

  test "should get new" do
    get :new, params:{server_id: 1}
    assert_response :success
  end

  test "should create maintenance_contract" do
    assert_difference('MaintenanceContract.count') do
      post :create, params: {maintenance_contract: { contract_type_id: @maintenance_contract.contract_type_id, end_date: @maintenance_contract.end_date, maintainer_id: @maintenance_contract.maintainer_id, start_date: @maintenance_contract.start_date, server_id: 2 }}
    end

    # Fixme: unstable test, get always different path when trying to fix, and even pass sometimes
    # assert_redirected_to server_path(2)
  end

  test "should show maintenance_contract" do
    get :show, params: {id: @maintenance_contract}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @maintenance_contract}
    assert_response :success
  end

  # Fixme: unstable test, get always different path when trying to fix, and even pass sometimes
  # test "should update maintenance_contract" do
  #   patch :update, params:{id: @maintenance_contract, maintenance_contract: { contract_type_id: @maintenance_contract.contract_type_id, end_date: @maintenance_contract.end_date, maintainer_id: @maintenance_contract.maintainer_id, start_date: @maintenance_contract.start_date, server_id: 2 }}
  #   assert_redirected_to server_path(2)
  # end

  test "should destroy maintenance_contract" do
    assert_difference('MaintenanceContract.count', -1) do
      delete :destroy, params: {id: @maintenance_contract}
    end

    assert_redirected_to maintenance_contracts_path
  end
end
