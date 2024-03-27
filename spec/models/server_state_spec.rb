# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServerState do
  subject(:server_state) { described_class.new(name: "Order In Progress") }

  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  describe "associations" do
    it { is_expected.to have_many(:servers) }
  end

  describe "#to_s" do
    it { expect(server_state.to_s).to eq server_state.name }
  end
end
