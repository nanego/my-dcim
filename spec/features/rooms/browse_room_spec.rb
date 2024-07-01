# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Rooms::BrowseRoom", :js do
  let(:user) { users(:one) }
  let(:room) { rooms(:one) }

  it("browse a room and its islets and bays") do # rubocop:disable RSpec/MultipleExpectations
    # First, sign in the user
    visit new_user_session_path
    expect(page).to have_current_path(new_user_session_path)

    within("form") do
      fill_form(:user, :new, {
        email: user.email,
        password: "passwordpassword"
      })

      click_on submit
    end

    visit room_path(room)

    expect(page).to have_current_path(room_path(room))
  end
end
