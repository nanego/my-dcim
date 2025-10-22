# frozen_string_literal: true

require "rails_helper"

RSpec.describe CablePolicy, type: :policy do
  let(:cable) { cables(:three) }
  let(:context) { { user: user } }
  let(:policy) { described_class.new(cable, user: user) }

  describe "relation scope" do
    subject { policy.apply_scope(target, type: :active_record_relation) }

    let(:target) { Cable.all }

    context "with admin" do
      let(:user) { users(:admin) }

      it { is_expected.to eq(target) }
    end

    context "with reader user" do
      let(:user) { users(:reader) }

      it { is_expected.to contain_exactly(cables(:five)) }
    end
  end

  it_behaves_like "with default index policy"
  it_behaves_like "with default create policy"
  it_behaves_like "with default manage policy"
end
