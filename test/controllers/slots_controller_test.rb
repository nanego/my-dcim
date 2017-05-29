require File.expand_path("../../test_helper", __FILE__)

class SlotsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @slot = slots(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:slots)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create slot" do
    assert_difference('Slot.count') do
      post :create, params: {slot: { server_id: @slot.server_id, valeur: @slot.valeur }}
    end

    assert_redirected_to slot_path(assigns(:slot))
  end

  test "should show slot" do
    get :show, params: {id: @slot}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @slot}
    assert_response :success
  end

  test "should update slot" do
    patch :update, params: {id: @slot, slot: { server_id: @slot.server_id, valeur: @slot.valeur }}
    assert_redirected_to slot_path(assigns(:slot))
  end

  test "should destroy slot" do
    assert_difference('Slot.count', -1) do
      delete :destroy, params: {id: @slot}
    end

    assert_redirected_to slots_path
  end
end
