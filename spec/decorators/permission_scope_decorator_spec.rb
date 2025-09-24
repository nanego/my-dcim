# frozen_string_literal: true

require "rails_helper"

RSpec.describe PermissionScopeDecorator, type: :decorator do
  let(:permission_scope) { permission_scopes(:all) }
  let(:decorated_permission_scope) { permission_scope.decorated }

  describe ".roles_for_options" do
    it { expect(described_class.roles_for_options.pluck(1)).to match_array(PermissionScope.roles.pluck(0)) }
  end

  describe ".users_for_options" do
    it do
      expect(described_class.users_for_options)
        .to match_array(
          users.map { |u| [u.to_s, u.id] },
        )
    end
  end
end
