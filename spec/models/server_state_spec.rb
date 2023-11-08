# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServerState, type: :model do
  subject(:server_state) { ServerState.new(name: "Order In Progress") }

  describe "associations" do
    it { is_expected.to have_many(:servers) }
  end

  describe "#to_s" do
    it { expect(server_state.to_s).to eq server_state.name }
  end
end
