# frozen_string_literal: true

require "rails_helper"

RSpec.describe PermissionScopeUserPolicy, type: :policy do
  let(:user) { users(:one) }
  let(:record) { users(:two) }
  let(:context) { { user: } }
  let(:is_admin) { true }

  before { user.is_admin = is_admin }

  %i[index? create? manage?].each do |rule|
    describe_rule rule do
      succeed "when an admin user asks"

      failed "when user is not admin" do
        let(:is_admin) { false }
      end
    end
  end
end
