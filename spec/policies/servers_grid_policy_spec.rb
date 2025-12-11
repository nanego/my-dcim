# frozen_string_literal: true

require "rails_helper"

RSpec.describe ServersGridPolicy, type: :policy do
  let(:server) { servers(:one) }
  let(:context) { { user: user } }
  let(:policy) { described_class.new(server, user: user) }

  describe_rule :index? do
    succeed "when an admin user asks" do
      let(:user) { users(:admin) }
    end

    succeed "when a writer user asks" do
      let(:user) { users(:writer) }
    end

    failed "when a reader user asks" do
      let(:user) { users(:reader) }
    end

    failed "when a reader all user asks" do
      let(:user) { users(:reader_all) }
    end
  end
end
