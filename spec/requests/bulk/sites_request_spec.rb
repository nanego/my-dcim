# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/sites" do
  before { sign_in users(:admin) }

  describe "DELETE /destroy" do
    context "with sites without associations" do
      it do
        expect do
          delete bulk_sites_path(ids: [sites(:four).id, sites(:five).id])
        end.to change(Site, :count).by(-2)
      end

      it do
        delete bulk_sites_path(ids: [sites(:four).id, sites(:five).id])
        expect(response).to redirect_to(sites_path)
      end
    end

    context "with a site with associations" do
      it do
        expect do
          delete bulk_sites_path(ids: [sites(:one).id])
        end.not_to change(Site, :count)
      end

      it do
        delete bulk_sites_path(ids: [sites(:one).id])
        expect(response).to redirect_to(sites_path)
      end
    end
  end
end
