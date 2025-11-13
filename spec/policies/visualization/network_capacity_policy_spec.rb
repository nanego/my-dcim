# frozen_string_literal: true

require "rails_helper"

RSpec.describe Visualization::NetworkCapacityPolicy, type: :policy do
  let(:context) { { user: user } }

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

    succeed "when a reader all users asks" do
      let(:user) { users(:reader_all) }
    end
  end
end
