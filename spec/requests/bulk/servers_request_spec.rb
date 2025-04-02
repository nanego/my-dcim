# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/servers" do
  before { sign_in users(:one) }

  describe "DELETE /destroy" do
    context "with a server without association" do
      it do
        expect do
          delete bulk_servers_path(ids: [servers(:two).id, servers(:four).id])
        end.to change(Server, :count).by(-2)
      end

      it do
        delete bulk_servers_path(ids: [servers(:two).id, servers(:four).id])
        expect(response).to redirect_to(servers_path)
      end
    end

    context "with a server with association" do
      it do
        expect do
          delete bulk_servers_path(ids: [servers(:one)])
        end.not_to change(Server, :count)
      end

      it do
        delete bulk_servers_path(ids: [servers(:one)])
        expect(response).to redirect_to(servers_path)
      end
    end
  end
end
