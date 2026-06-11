# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bulk::PowerDistributionUnitsController do
  before { sign_in users(:admin) }

  describe "DELETE #destroy" do
    subject(:response) do
      delete bulk_power_distribution_units_path(ids:)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:ids) { [power_distribution_units(:one).id, power_distribution_units(:two).id] }

    it { expect { response }.to change(PowerDistributionUnit, :count).by(-2) }
    it { expect(response).to redirect_to(power_distribution_units_path) }
  end
end
