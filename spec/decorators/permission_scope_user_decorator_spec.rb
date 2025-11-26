# frozen_string_literal: true

require "rails_helper"

RSpec.describe PermissionScopeUserDecorator, type: :decorator do
  let(:permission_scope_user) { permission_scope_users(:one) }
  let(:permission_scope) { permission_scope_user.permission_scope }
  let(:decorated_permission_scope_user) { permission_scope_user.decorated }

  describe ".users_options_for_select" do
    it do
      expect(described_class.users_options_for_select(permission_scope))
        .to contain_exactly(
          ["/dev/null", 6, {}], ["Admin", 135_138_680, {}], ["Reader", 4, {}], ["Reader All", 7, {}],
          ["User2", 298_486_374, {}], ["Writer", 5, {}],
        )
    end
  end
end
