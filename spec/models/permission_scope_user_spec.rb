# frozen_string_literal: true

require "rails_helper"

RSpec.describe PermissionScopeUser do
  subject(:permission_scope_user) do
    described_class.new(permission_scope: permission_scopes(:one), user: users(:one))
  end

  describe "associations" do
    it { is_expected.to belong_to(:permission_scope) }
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to be_valid }
  end
end
