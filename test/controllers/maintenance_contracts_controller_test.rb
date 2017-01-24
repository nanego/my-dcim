require 'test_helper'

class MaintenanceContractsControllerTest < ActionController::TestCase
  setup do
    @maintenance_contract = maintenance_contracts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:maintenance_contracts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create maintenance_contract" do
    assert_difference('MaintenanceContract.count') do
      post :create, maintenance_contract: { contract_type_id: @maintenance_contract.contract_type_id, end_date: @maintenance_contract.end_date, maintainer_id: @maintenance_contract.maintainer_id, start_date: @maintenance_contract.start_date }
    end

    assert_redirected_to maintenance_contract_path(assigns(:maintenance_contract))
  end

  test "should show maintenance_contract" do
    get :show, id: @maintenance_contract
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @maintenance_contract
    assert_response :success
  end

  test "should update maintenance_contract" do
    patch :update, id: @maintenance_contract, maintenance_contract: { contract_type_id: @maintenance_contract.contract_type_id, end_date: @maintenance_contract.end_date, maintainer_id: @maintenance_contract.maintainer_id, start_date: @maintenance_contract.start_date }
    assert_redirected_to maintenance_contract_path(assigns(:maintenance_contract))
  end

  test "should destroy maintenance_contract" do
    assert_difference('MaintenanceContract.count', -1) do
      delete :destroy, id: @maintenance_contract
    end

    assert_redirected_to maintenance_contracts_path
  end
end
