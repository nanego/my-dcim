# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserPolicy, type: :policy do # rubocop:disable RSpec/EmptyExampleGroup
  let(:user) { users(:one) }
  let(:record) { users(:two) }
  let(:context) { { user: } }
  let(:role) { :admin }

  before { context[:user].role = role }

  describe_rule :edit_user? do
    succeed "when an admin user asks"

    %i[user vip].each do |unauthorized_role|
      failed "when user is #{unauthorized_role}" do
        let(:role) { unauthorized_role }
      end
    end
  end

  describe_rule :update_user? do
    succeed "when an admin user asks"

    %i[user vip].each do |unauthorized_role|
      failed "when user is #{unauthorized_role}" do
        let(:role) { unauthorized_role }
      end
    end
  end
end
