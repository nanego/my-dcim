# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bulk::PowerDistributionUnitTypesController do
  describe "DELETE #destroy" do
    subject(:response) do
      delete bulk_power_distribution_unit_types_path(ids:)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:ids) { [] }

    include_context "with authenticated admin"

    context "with power_distribution_unit_types without associations" do
      let(:ids) { [power_distribution_unit_types(:two).id, power_distribution_unit_types(:three).id] }

      it { expect { response }.to change(PowerDistributionUnitType, :count).by(-2) }
      it { expect(response).to redirect_to(power_distribution_unit_types_path) }
    end

    context "with power_distribution_unit_types with associations" do
      let(:ids) { [power_distribution_unit_types(:one).id] }

      it { expect { response }.not_to change(PowerDistributionUnitType, :count) }
      it { expect(response).to redirect_to(power_distribution_unit_types_path) }
    end
  end
end
