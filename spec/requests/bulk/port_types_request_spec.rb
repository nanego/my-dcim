# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/port_types" do
  before { sign_in users(:admin) }

  describe "DELETE /destroy" do
    context "with port types without associations" do
      it do
        expect do
          delete bulk_port_types_path(ids: [port_types(:five).id, port_types(:six).id])
        end.to change(PortType, :count).by(-2)
      end

      it do
        delete bulk_port_types_path(ids: [port_types(:five).id, port_types(:six).id])
        expect(response).to redirect_to(port_types_path)
      end
    end
  end
end
