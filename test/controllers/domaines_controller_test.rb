# frozen_string_literal: true

require File.expand_path("../test_helper", __dir__)

class DomainesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:admin)
    @domaine = domaines(:switch)
  end

  test "should get edit" do
    get :edit, params: { id: @domaine }
    assert_response :success
  end

  test "should update domaine" do
    patch :update, params: { id: @domaine, domaine: { description: @domaine.description, name: @domaine.name } }
    assert_redirected_to domaine_path(assigns(:domaine))
  end

  test "should destroy domaine" do
    @domaine = Domaine.create

    assert_difference("Domaine.count", -1) do
      delete :destroy, params: { id: @domaine, confirm: true }
    end

    assert_redirected_to domaines_path
  end

  test "should not destroy domaine that have modeles" do
    assert_difference("Domaine.count", 0) do
      delete :destroy, params: { id: @domaine, confirm: true }
    end

    assert_redirected_to domaines_path
  end
end
