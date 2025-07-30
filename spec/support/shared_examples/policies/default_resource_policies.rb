# frozen_string_literal: true

RSpec.shared_context "with default resource policies", type: :policy do |excluded_policies: []|
  let(:user) { users(:one) }
  let(:context) { { user: } }
  let(:is_admin) { false }
  let(:role) { nil }

  before do
    user.is_admin = is_admin
    user.role = role
  end

  if excluded_policies.exclude?(:show?)
    describe_rule :show? do
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

  if excluded_policies.exclude?(:new?)
    describe_rule :new? do
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

  if excluded_policies.exclude?(:edit?)
    describe_rule :edit? do
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

  if excluded_policies.exclude?(:destroy?)
    describe_rule :destroy? do
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
end
