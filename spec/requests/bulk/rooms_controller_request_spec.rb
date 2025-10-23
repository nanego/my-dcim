# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bulk::RoomsController do
  before { sign_in users(:admin) }

  describe "DELETE #destroy" do
    subject(:response) do
      delete bulk_rooms_path(ids:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:ids) { [] }

    context "with rooms without associations" do
      let(:ids) { [rooms(:two).id, rooms(:three).id] }

      it { expect { response }.to have_authorized_scope(:active_record_relation).with(RoomPolicy) }
      it { expect { response }.to change(Room, :count).by(-2) }
      it { expect(response).to redirect_to(rooms_path) }
    end

    context "with a room with associations" do
      let(:ids) { [rooms(:one).id] }

      it { expect { response }.to have_authorized_scope(:active_record_relation).with(RoomPolicy) }
      it { expect { response }.not_to change(Room, :count) }
      it { expect(response).to redirect_to(rooms_path) }
    end
  end
end
