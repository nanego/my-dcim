# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/bays" do
  before { sign_in users(:admin) }

  describe "DELETE /destroy" do
    context "with bays without associations" do
      it do
        expect do
          delete bulk_bays_path(ids: [bays(:three).id, bays(:five).id])
        end.to change(Bay, :count).by(-2)
      end

      it do
        delete bulk_bays_path(ids: [bays(:three).id, bays(:five).id])
        expect(response).to redirect_to(bays_path)
      end
    end

    context "with a bay with associations" do
      it do
        expect do
          delete bulk_bays_path(ids: [bays(:one).id])
        end.not_to change(Bay, :count)
      end

      it do
        delete bulk_bays_path(ids: [bays(:one).id])
        expect(response).to redirect_to(bays_path)
      end
    end
  end
end
