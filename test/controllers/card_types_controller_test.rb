# frozen_string_literal: true

require File.expand_path("../../test_helper", __FILE__)

class CardTypesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @card_type = card_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:card_types_by_port_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create card type" do
    assert_difference('CardType.count') do
      post :create, params: { card_type: {
        port_type_id: @card_type.port_type_id, name: @card_type.name, port_quantity: @card_type.port_quantity
      } }
    end

    assert_redirected_to card_types_path
  end

  test "should show card type" do
    get :show, params: { id: @card_type }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @card_type }
    assert_response :success
  end

  test "should update card_type" do
    patch :update, params: {
      id: @card_type,
      card_type: {
        port_quantity: @card_type.port_quantity,
        name: @card_type.name,
        port_type_id: @card_type.port_type_id
      }
    }

    assert_redirected_to card_types_path
  end

  test "should destroy card_type" do
    @card_type = card_types(:three)

    assert_difference('CardType.count', -1) do
      delete :destroy, params: { id: @card_type }
    end

    assert_redirected_to card_types_path
  end

  test "should not destroy card_type that have modeles" do
    assert_difference('CardType.count', 0) do
      delete :destroy, params: {id: @card_type}
    end

    assert_redirected_to card_types_path
  end
end
