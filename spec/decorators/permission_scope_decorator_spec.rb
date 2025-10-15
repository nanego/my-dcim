# frozen_string_literal: true

require "rails_helper"

RSpec.describe PermissionScopeDecorator, type: :decorator do
  let(:permission_scope) { permission_scopes(:all) }
  let(:decorated_permission_scope) { permission_scope.decorated }

  describe ".roles_options_for_select" do
    it { expect(described_class.roles_options_for_select.pluck(1)).to match_array(PermissionScope.roles.pluck(0)) }
  end

  describe ".users_options_for_select" do
    it do
      expect(described_class.users_options_for_select)
        .to match_array(
          users.map { |u| [u.to_s, u.id] },
        )
    end
  end
end
