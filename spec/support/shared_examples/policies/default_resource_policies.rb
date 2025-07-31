# frozen_string_literal: true

RSpec.shared_context "with default index policy", type: :policy do
  let(:user) { users(:one) }
  let(:context) { { user: } }
  let(:is_admin) { false }
  let(:role) { nil }

  before do
    user.is_admin = is_admin
    user.role = role
  end

  describe_rule :index? do
    context "when user is admin" do # rubocop:disable Spec/EmptyExampleGroup
      succeed "when an admin user asks" do
        let(:is_admin) { true }
      end
    end

    context "when user is not admin" do # rubocop:disable Spec/EmptyExampleGroup
      failed "when user with no role asks"

      succeed "when a reader user asks" do
        let(:role) { :reader }
      end

      succeed "when a writer user asks" do
        let(:role) { :writer }
      end
    end
  end
end

RSpec.shared_context "with default create policy", type: :policy do
  let(:user) { users(:one) }
  let(:context) { { user: } }
  let(:is_admin) { false }
  let(:role) { nil }

  before do
    user.is_admin = is_admin
    user.role = role
  end

  describe_rule :create? do
    context "when user is admin" do # rubocop:disable Spec/EmptyExampleGroup
      succeed "when an admin user asks" do
        let(:is_admin) { true }
      end
    end

    context "when user is not admin" do # rubocop:disable Spec/EmptyExampleGroup
      failed "when user with no role asks"

      failed "when a reader user asks" do
        let(:role) { :reader }
      end

      succeed "when a writer user asks" do
        let(:role) { :writer }
      end
    end
  end
end

RSpec.shared_context "with default manage policy", type: :policy do
  let(:user) { users(:one) }
  let(:context) { { user: } }
  let(:is_admin) { false }
  let(:role) { nil }

  before do
    user.is_admin = is_admin
    user.role = role
  end

  describe_rule :manage? do
    context "when user is admin" do # rubocop:disable Spec/EmptyExampleGroup
      succeed "when an admin user asks" do
        let(:is_admin) { true }
      end
    end

    context "when user is not admin" do # rubocop:disable Spec/EmptyExampleGroup
      failed "when user with no role asks"

      failed "when a reader user asks" do
        let(:role) { :reader }
      end

      succeed "when a writer user asks" do
        let(:role) { :writer }
      end
    end
  end
end
