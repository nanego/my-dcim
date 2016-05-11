require 'test_helper'

class CoupleBaiesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @couple_baie = couple_baies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:couple_baies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create couple_baie" do
    assert_difference('CoupleBaie.count') do
      post :create, couple_baie: { baie_one_id: @couple_baie.baie_one_id, baie_two_id: @couple_baie.baie_two_id }
    end

    assert_redirected_to couple_baie_path(assigns(:couple_baie))
  end

  test "should show couple_baie" do
    get :show, id: @couple_baie
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @couple_baie
    assert_response :success
  end

  test "should update couple_baie" do
    patch :update, id: @couple_baie, couple_baie: { baie_one_id: @couple_baie.baie_one_id, baie_two_id: @couple_baie.baie_two_id }
    assert_redirected_to couple_baie_path(assigns(:couple_baie))
  end

  test "should destroy couple_baie" do
    assert_difference('CoupleBaie.count', -1) do
      delete :destroy, id: @couple_baie
    end

    assert_redirected_to couple_baies_path
  end
end
