# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnitPolicy, type: :policy do
  let(:power_distribution_unit) { power_distribution_units(:one) }
  let(:context) { { user: user } }
  let(:policy) { described_class.new(power_distribution_unit, user: user) }

  describe "relation scope" do
    subject { policy.apply_scope(target, type: :active_record_relation) }

    let(:target) { PowerDistributionUnit.all }

    context "with admin" do
      let(:user) { users(:admin) }

      it { is_expected.to match_array(target) }
    end

    context "with writer user" do
      let(:user) { users(:writer) }

      it { is_expected.to match_array(target) }
    end

    context "with reader user" do
      let(:user) { users(:reader) }

      it { is_expected.to contain_exactly(power_distribution_units(:one)) }
    end

    context "with reader all user" do
      let(:user) { users(:reader_all) }

      it { is_expected.to match_array(target) }
    end
  end

  it_behaves_like "with default index policy"
  it_behaves_like "with default create policy"
  it_behaves_like "with default manage policy"

  it_behaves_like "act as manage policy", for: :duplicate?
end
