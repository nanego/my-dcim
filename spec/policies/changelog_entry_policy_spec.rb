# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChangelogEntryPolicy, type: :policy do
  let(:user) { users(:one) }
  let(:context) { { user: } }

  describe_rule :index? do
    context "when user is admin" do
      succeed "when an admin user asks" do
        let(:user) { users(:admin) }
      end
    end

    context "when user is not admin" do
      failed "when user with no role asks"

      failed "when a reader user asks" do
        let(:user) { users(:reader) }
      end

      succeed "when a reader users asks with a scoped_object (ChangelogEntries::ObjectList context)" do
        let(:user) { users(:reader) }
        let(:context) { { user:, scoped_object: Server.first } }
      end

      succeed "when a writer user asks" do
        let(:user) { users(:writer) }
      end
    end
  end

  it_behaves_like "with default create policy"
  it_behaves_like "with default manage policy"
end
