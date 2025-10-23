# frozen_string_literal: true

require "rails_helper"

RSpec.describe PermissionScopePolicy, type: :policy do
  let(:user) { users(:one) }
  let(:record) { users(:two) }
  let(:context) { { user: } }
  let(:is_admin) { true }

  before { user.is_admin = is_admin }

  describe_rule :index? do
    succeed "when an admin user asks"

    failed "when user is not admin" do
      let(:is_admin) { false }
    end
  end

  describe_rule :create? do
    succeed "when an admin user asks"

    failed "when user is not admin" do
      let(:is_admin) { false }
    end
  end

  describe_rule :manage? do
    succeed "when an admin user asks"

    failed "when user is not admin" do
      let(:is_admin) { false }
    end
  end
end
