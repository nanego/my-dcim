# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchResult do
  describe "associations" do
    it { is_expected.to belong_to(:searchable) }
  end

  describe ".search" do
    subject(:search_results) { described_class.search("frame") }

    it { is_expected.to all(be_a(described_class)) }

    it do # rubocop:disable RSpec/ExampleLength
      expect(search_results.map(&:searchable)).to contain_exactly(
        servers(:pdu),
        frames(:one),
        frames(:two),
        frames(:three),
        frames(:four),
        frames(:five),
      )
    end
  end
end
