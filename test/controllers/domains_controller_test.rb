# frozen_string_literal: true

require File.expand_path("../test_helper", __dir__)

class DomainsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:admin)
    @domain = domains(:switch)
  end

  test "should get edit" do
    get :edit, params: { id: @domain }
    assert_response :success
  end

  test "should update domain" do
    patch :update, params: { id: @domain, domain: { description: @domain.description, name: @domain.name } }
    assert_redirected_to domain_path(assigns(:domain))
  end

  test "should destroy domain" do
    @domain = Domain.create

    assert_difference("Domain.count", -1) do
      delete :destroy, params: { id: @domain, confirm: true }
    end

    assert_redirected_to domains_path
  end

  test "should not destroy domain that have modeles" do
    assert_difference("Domain.count", 0) do
      delete :destroy, params: { id: @domain, confirm: true }
    end

    assert_redirected_to domains_path
  end
end
