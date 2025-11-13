# frozen_string_literal: true

require "rails_helper"

RSpec.describe FramePolicy, type: :policy do
  let(:frame) { frames(:three) }
  let(:context) { { user: user } }
  let(:policy) { described_class.new(frame, user: user) }

  describe "relation scope" do
    subject { policy.apply_scope(target, type: :active_record_relation) }

    let(:target) { Frame.all }

    context "with admin" do
      let(:user) { users(:admin) }

      it { is_expected.to match_array(target) }
    end

    context "with writer user" do
      let(:user) { users(:writer) }

      it { is_expected.to match_array(target) }
    end

    context "with reader all user" do
      let(:user) { users(:reader_all) }

      it { is_expected.to match_array(target) }
    end

    context "with reader user" do
      let(:user) { users(:reader) }

      it { is_expected.to contain_exactly(frames(:one)) }
    end
  end

  it_behaves_like "with default index policy"
  it_behaves_like "with default create policy"
  it_behaves_like "with default manage policy"

  it_behaves_like "act as manage policy", for: :sort?
  it_behaves_like "act as index policy", for: :network?

  describe_rule :show? do
    succeed "when an admin user asks" do
      let(:user) { users(:admin) }
    end

    succeed "when a writer user asks" do
      let(:user) { users(:writer) }
    end

    failed "when a reader user asks" do
      let(:user) { users(:reader) }
    end

    succeed "when a reader users asks on a permitted server" do
      let(:user) { users(:reader) }
      let(:frame) { frames(:one) }
    end

    succeed "when a reader all users asks" do
      let(:user) { users(:reader_all) }
    end
  end
end
