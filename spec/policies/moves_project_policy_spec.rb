# frozen_string_literal: true

require "rails_helper"

RSpec.describe MovesProjectPolicy, type: :policy do
  let(:user) { users(:one) }
  let(:context) { { user: } }
  let(:is_admin) { false }
  let(:role) { nil }

  before do
    user.is_admin = is_admin
    user.role = role
  end

  it_behaves_like "with default index policy"
  it_behaves_like "with default create policy"
  it_behaves_like "with default manage policy"

  describe_rule :archive? do
    context "when user is admin" do # rubocop:disable Spec/EmptyExampleGroup
      succeed "when an admin user asks" do
        let(:is_admin) { true }
      end
    end

    context "when user is not admin" do # rubocop:disable Spec/EmptyExampleGroup
      failed "when user with no role asks"

      failed "when a reader user asks" do
        let(:role) { :reader }
      end

      succeed "when a writer user asks" do
        let(:role) { :writer }
      end
    end
  end
end
