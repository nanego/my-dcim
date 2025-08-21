# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/rooms" do
  before { sign_in users(:admin) }

  describe "DELETE /destroy" do
    context "with rooms without associations" do
      it do
        expect do
          delete bulk_rooms_path(ids: [rooms(:two).id, rooms(:three).id])
        end.to change(Room, :count).by(-2)
      end

      it do
        delete bulk_rooms_path(ids: [rooms(:two).id, rooms(:three).id])
        expect(response).to redirect_to(rooms_path)
      end
    end

    context "with a room with associations" do
      it do
        expect do
          delete bulk_rooms_path(ids: [rooms(:one).id])
        end.not_to change(Room, :count)
      end

      it do
        delete bulk_rooms_path(ids: [rooms(:one).id])
        expect(response).to redirect_to(rooms_path)
      end
    end
  end
end
