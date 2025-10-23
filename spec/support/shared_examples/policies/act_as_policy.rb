# frozen_string_literal: true

RSpec.shared_context "act as index policy", type: :policy do |**kwargs| # rubocop:disable RSpec/ContextWording
  let(:user) { users(:one) }
  let(:context) { { user: } }
  let(:is_admin) { false }

  before do
    user.is_admin = is_admin
  end

  describe_rule kwargs[:for] do
    context "when user is admin" do
      succeed "when an admin user asks" do
        let(:is_admin) { true }
      end
    end

    context "when user is not admin" do
      succeed "when a reader user asks" do
        let(:user) { users(:reader) }
      end

      succeed "when a writer user asks" do
        let(:user) { users(:writer) }
      end
    end
  end
end

RSpec.shared_context "act as create policy", type: :policy do |**kwargs| # rubocop:disable RSpec/ContextWording
  let(:user) { users(:one) }
  let(:context) { { user: } }
  let(:is_admin) { false }

  before do
    user.is_admin = is_admin
  end

  describe_rule kwargs[:for] do
    context "when user is admin" do
      succeed "when an admin user asks" do
        let(:is_admin) { true }
      end
    end

    context "when user is not admin" do
      failed "when a reader user asks" do
        let(:user) { users(:reader) }
      end

      succeed "when a writer user asks" do
        let(:user) { users(:writer) }
      end
    end
  end
end

RSpec.shared_context "act as manage policy", type: :policy do |**kwargs| # rubocop:disable RSpec/ContextWording
  let(:user) { users(:one) }
  let(:context) { { user: } }
  let(:is_admin) { false }

  before do
    user.is_admin = is_admin
  end

  describe_rule kwargs[:for] do
    context "when user is admin" do
      succeed "when an admin user asks" do
        let(:is_admin) { true }
      end
    end

    context "when user is not admin" do
      failed "when a reader user asks" do
        let(:user) { users(:reader) }
      end

      succeed "when a writer user asks" do
        let(:user) { users(:writer) }
      end
    end
  end
end
