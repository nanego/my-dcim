# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Rooms::BrowseRoom", :js do
  let(:user) { users(:one) }
  let(:room) { rooms(:one) }

  it("browse a room and its islets and bays") do
    sign_in(user)

    visit room_path(room)
    expect(page).to have_current_path(room_path(room))
  end
end
