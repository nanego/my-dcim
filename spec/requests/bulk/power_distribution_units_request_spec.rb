# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/power_distribution_units" do
  before { sign_in users(:admin) }

  describe "DELETE /destroy" do
    context "with a power distribution units without association" do
      it do
        expect do
          delete bulk_power_distribution_units_path(ids: [servers(:pdu2).id])
        end.to change(Server, :count).by(-1)
      end

      it do
        delete bulk_power_distribution_units_path(ids: [servers(:pdu2).id])
        expect(response).to redirect_to(power_distribution_units_path)
      end
    end

    context "with a power distribution unit with association" do
      it do
        expect do
          delete bulk_power_distribution_units_path(ids: [servers(:pdu).id])
        end.not_to change(Server, :count)
      end

      it do
        delete bulk_power_distribution_units_path(ids: [servers(:pdu).id])
        expect(response).to redirect_to(power_distribution_units_path)
      end
    end
  end
end
