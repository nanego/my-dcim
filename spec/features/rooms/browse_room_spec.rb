# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Rooms::BrowseRoom", :js do
  let(:room) { rooms(:one) }

  it("browse a room and its islets and bays") do
    sign_in(users(:one))

    visit room_path(room, 'islet-id': room.islets.first, 'bay-id': room.bays.first, 'frame-id': room.frames.first, view: "front")
    expect(page).to have_current_path(room_path(room, 'islet-id': room.islets.first, 'bay-id': room.bays.first, 'frame-id': room.frames.first, view: "front"))
  end
end
