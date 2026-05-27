# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bulk::PowerDistributionUnitTypesController do
  before { sign_in users(:admin) }

  describe "DELETE #destroy" do
    subject(:response) do
      delete bulk_power_distribution_unit_types_path(ids:)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:ids) { [power_distribution_unit_types(:one).id, power_distribution_unit_types(:two).id] }

    it { expect { response }.to change(PowerDistributionUnitType, :count).by(-2) }
    it { expect(response).to redirect_to(power_distribution_unit_types_path) }
  end
end
