# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchResultPolicy, type: :policy do
  let(:search_result) { SearchResult.new(searchable: servers(:one)) }
  let(:context) { { user: user } }
  let(:policy) { described_class.new(search_result, user: user) }

  describe "relation scope" do
    subject { policy.apply_scope(target, type: :active_record_relation) }

    let(:target) { SearchResult.search("Server") }

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
end
