# frozen_string_literal: true

require "rails_helper"

RSpec.describe DomainePolicy, type: :policy do
  let(:domaine) { domaines(:three) }
  let(:context) { { user: user } }
  let(:policy) { described_class.new(domaine, user: user) }

  describe "relation scope" do
    subject { policy.apply_scope(target, type: :active_record_relation) }

    let(:target) { Domaine.all }

    context "with admin" do
      let(:user) { users(:admin) }

      it { is_expected.to match_array(target) }
    end

    context "with reader user" do
      let(:user) { users(:reader) }

      it { is_expected.to contain_exactly(domaines(:three)) }
    end
  end

  it_behaves_like "with default index policy"
  it_behaves_like "with default create policy"
  it_behaves_like "with default manage policy"
end
