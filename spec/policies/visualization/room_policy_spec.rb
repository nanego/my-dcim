# frozen_string_literal: true

require "rails_helper"

RSpec.describe Visualization::RoomPolicy, type: :policy do
  let(:policy) { described_class.new(room, user: user) }
  let(:context) { { user: user } }
  let(:room) { rooms(:three) }

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
      let(:room) { rooms(:one) }
    end
  end
end
