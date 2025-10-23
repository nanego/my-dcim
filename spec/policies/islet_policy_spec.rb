# frozen_string_literal: true

require "rails_helper"

RSpec.describe IsletPolicy, type: :policy do
  let(:islet) { islets(:three) }
  let(:context) { { user: user } }
  let(:policy) { described_class.new(islet, user: user) }

  describe "relation scope" do
    subject { policy.apply_scope(target, type: :active_record_relation) }

    let(:target) { Islet.all }

    context "with admin" do
      let(:user) { users(:admin) }

      it { is_expected.to match_array(target) }
    end

    context "with reader user" do
      let(:user) { users(:reader) }

      it { is_expected.to contain_exactly(islets(:one)) }
    end
  end

  it_behaves_like "with default index policy"
  it_behaves_like "with default create policy"
  it_behaves_like "with default manage policy"

  it_behaves_like "act as index policy", for: :print?
end
