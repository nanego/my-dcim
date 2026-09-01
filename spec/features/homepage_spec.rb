# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Homepage" do
  it "anonymous user visits homepage", :aggregate_failures do
    visit root_url
    expect(page).to have_current_path(new_user_session_url)

    expect(page).to have_text("Vous devez vous connecter ou vous inscrire pour continuer.")
  end

  it "logged in user visits homepage", :aggregate_failures do
    sign_in users(:reader)

    visit root_url
    expect(page).to have_current_path(root_url)

    main = page.first("main")
    expect(main).to have_text("Gestion de salle")
    expect(main).to have_link("S1")
    expect(main).to have_no_link("S3")
  end
end
