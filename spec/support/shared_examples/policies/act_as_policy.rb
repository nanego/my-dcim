# frozen_string_literal: true

RSpec.shared_context "act as index policy", type: :policy do |**kwargs| # rubocop:disable RSpec/ContextWording
  let(:user) { users(:one) }
  let(:context) { { user: } }
  let(:is_admin) { false }
  let(:role) { nil }

  before do
    user.is_admin = is_admin
    user.role = role
  end

  describe_rule kwargs[:for] do
    context "when user is admin" do # rubocop:disable RSpec/EmptyExampleGroup
      succeed "when an admin user asks" do
        let(:is_admin) { true }
      end
    end

    context "when user is not admin" do # rubocop:disable RSpec/EmptyExampleGroup
      succeed "when a reader user asks" do
        let(:role) { :reader }
      end

      succeed "when a writer user asks" do
        let(:role) { :writer }
      end
    end
  end
end

RSpec.shared_context "act as create policy", type: :policy do |**kwargs| # rubocop:disable RSpec/ContextWording
  let(:user) { users(:one) }
  let(:context) { { user: } }
  let(:is_admin) { false }
  let(:role) { nil }

  before do
    user.is_admin = is_admin
    user.role = role
  end

  describe_rule kwargs[:for] do
    context "when user is admin" do # rubocop:disable RSpec/EmptyExampleGroup
      succeed "when an admin user asks" do
        let(:is_admin) { true }
      end
    end

    context "when user is not admin" do # rubocop:disable RSpec/EmptyExampleGroup
      failed "when a reader user asks" do
        let(:role) { :reader }
      end

      succeed "when a writer user asks" do
        let(:role) { :writer }
      end
    end
  end
end

RSpec.shared_context "act as manage policy", type: :policy do |**kwargs| # rubocop:disable RSpec/ContextWording
  let(:user) { users(:one) }
  let(:context) { { user: } }
  let(:is_admin) { false }
  let(:role) { nil }

  before do
    user.is_admin = is_admin
    user.role = role
  end

  describe_rule kwargs[:for] do
    context "when user is admin" do # rubocop:disable RSpec/EmptyExampleGroup
      succeed "when an admin user asks" do
        let(:is_admin) { true }
      end
    end

    context "when user is not admin" do # rubocop:disable RSpec/EmptyExampleGroup
      failed "when a reader user asks" do
        let(:role) { :reader }
      end

      succeed "when a writer user asks" do
        let(:role) { :writer }
      end
    end
  end
end
