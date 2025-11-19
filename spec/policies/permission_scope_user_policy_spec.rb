# frozen_string_literal: true

require "rails_helper"

RSpec.describe PermissionScopeUserPolicy, type: :policy do
  let(:user) { users(:one) }
  let(:record) { users(:two) }
  let(:context) { { user: } }

  %i[index? create? manage?].each do |rule|
    describe_rule rule do
      succeed "when an admin user asks" do
        let(:user) { users(:admin) }
      end

      failed "when user is not admin" do
        let(:user) { users(:reader) }
      end
    end
  end
end
