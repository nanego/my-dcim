# frozen_string_literal: true

require "test_helper"

class HomepageTest < ActionDispatch::IntegrationTest
  test "anonymous user visits homepage" do
    visit root_url
    assert page.has_content?("Vous devez vous connecter ou vous inscrire pour continuer.")
  end

  test "logged in user visits homepage" do
    sign_in users(:one)
    visit root_url

    assert page.first("main").has_content?("Gestion de salle")
    assert page.first("main").has_link?("S1")
    assert page.first("main").has_no_link?("S3")
  end
end
