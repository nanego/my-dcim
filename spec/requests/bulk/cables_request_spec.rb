# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/cables" do
  before { sign_in users(:admin) }

  describe "DELETE /destroy" do
    context "with cables without associations" do
      it do
        expect do
          delete bulk_cables_path(ids: [cables(:one).id, cables(:two).id])
        end.to change(Cable, :count).by(-2)
      end

      it do
        delete bulk_cables_path(ids: [cables(:one).id, cables(:two).id])
        expect(response).to redirect_to(cables_path)
      end
    end
  end
end
