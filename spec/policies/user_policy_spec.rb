# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserPolicy, type: :policy do
  let(:user) { users(:one) }
  let(:record) { users(:two) }
  let(:context) { { user: } }
  let(:is_admin) { true }

  before { context[:user].is_admin = is_admin }

  describe_rule :index? do
    succeed "when an admin user asks"

    failed "when user is not admin" do
      let(:is_admin) { false }
    end
  end

  describe_rule :show? do
    succeed "when an admin user asks"
    succeed "when user asks for itself" do
      let(:record) { user }
    end

    failed "when user is not admin" do
      let(:is_admin) { false }
    end
  end

  describe_rule :new? do
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

  %i[destroy? suspend? unsuspend?].each do |rule|
    describe_rule rule do
      succeed "when an admin user asks"
      failed "when user asks for itself" do
        let(:record) { user }
      end

      failed "when user is not admin" do
        let(:is_admin) { false }
      end
    end
  end
end
