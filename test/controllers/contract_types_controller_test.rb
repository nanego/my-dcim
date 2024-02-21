# frozen_string_literal: true

require 'test_helper'

class ContractTypesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @contract_type = contract_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contract_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contract_type" do
    assert_difference('ContractType.count') do
      post :create, params: { contract_type: { name: @contract_type.name } }
    end

    assert_redirected_to contract_type_path(assigns(:contract_type))
  end

  test "should show contract_type" do
    get :show, params: { id: @contract_type }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @contract_type }
    assert_response :success
  end

  test "should update contract_type" do
    patch :update, params: { id: @contract_type, contract_type: { name: @contract_type.name } }
    assert_redirected_to contract_type_path(assigns(:contract_type))
  end

  test "should not destroy contract_type" do
    assert_difference('ContractType.count', 0) do
      delete :destroy, params: { id: @contract_type }
    end

    assert_redirected_to contract_types_path
  end

  test "should destroy contract_type" do
    @contract_type = ContractType.create

    assert_difference('ContractType.count', -1) do
      delete :destroy, params: { id: @contract_type }
    end

    assert_redirected_to contract_types_path
  end
end
