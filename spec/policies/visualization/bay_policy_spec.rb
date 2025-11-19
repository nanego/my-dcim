# frozen_string_literal: true

require "rails_helper"

RSpec.describe Visualization::BayPolicy, type: :policy do
  let(:bay) { bays(:three) }
  let(:context) { { user: user } }

  let(:policy) { described_class.new(bay, user: user) }

  it_behaves_like "with default index policy"

  it_behaves_like "act as manage policy", for: :print?

  describe_rule :show? do
    succeed "when an admin user asks" do
      let(:user) { users(:admin) }
    end

    succeed "when a writer user asks" do
      let(:user) { users(:writer) }
    end

    failed "when a reader user asks" do
      let(:user) { users(:reader) }
    end

    succeed "when a reader users asks on a permitted server" do
      let(:user) { users(:reader) }
      let(:bay) { bays(:one) }
    end

    succeed "when a reader all users asks" do
      let(:user) { users(:reader_all) }
    end
  end
end
