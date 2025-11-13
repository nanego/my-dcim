# frozen_string_literal: true

require "rails_helper"

RSpec.describe ServerPolicy, type: :policy do
  let(:server) { servers(:one) }
  let(:context) { { user: user } }
  let(:policy) { described_class.new(server, user: user) }

  describe "relation scope" do
    subject { policy.apply_scope(target, type: :active_record_relation) }

    let(:target) { Server.no_pdus }

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

      it { is_expected.to contain_exactly(servers(:accesible_to_readers)) }
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
  it_behaves_like "act as manage policy", for: :sort?
  it_behaves_like "act as manage policy", for: :import?
  it_behaves_like "act as manage policy", for: :import_csv?
  it_behaves_like "act as manage policy", for: :export?

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
      let(:server) { servers(:accesible_to_readers) }
    end

    succeed "when a reader all users asks" do
      let(:user) { users(:reader_all) }
    end
  end
end
