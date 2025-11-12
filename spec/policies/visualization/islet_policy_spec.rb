# frozen_string_literal: true

require "rails_helper"

RSpec.describe Visualization::IsletPolicy, type: :policy do
  let(:islet) { islets(:three) }
  let(:context) { { user: user } }
  let(:policy) { described_class.new(islet, user: user) }

  it_behaves_like "with default index policy"

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
      let(:islet) { islets(:one) }
    end
  end
end
