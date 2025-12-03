# frozen_string_literal: true

require "rails_helper"

RSpec.describe PermissionScopePolicy, type: :policy do
  let(:user) { users(:one) }
  let(:record) { permission_scopes(:writer) }
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

  describe_rule :destroy? do
    succeed "when an admin user asks and permission scope is not system"

    failed "when user is admin and permission scope is system" do
      let(:record) { permission_scopes(:is_system) }
    end

    failed "when user is not admin" do
      let(:is_admin) { false }
    end
  end
end
