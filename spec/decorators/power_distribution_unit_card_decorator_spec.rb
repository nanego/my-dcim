# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnitCardDecorator, type: :decorator do
  describe ".card_type_grouped_by_port_type_options_for_select" do
    it do # rubocop:disable RSpec/ExampleLength
      expect(described_class.card_type_grouped_by_port_type_options_for_select)
        .to contain_exactly(
          ["ALIM", [["Card6", 6]]], ["FC", [["Card3", 3]]],
          ["Five", []],
          ["IPMI", [["Card1", 1], ["6ALIM", 4], ["Card5", 5]]],
          ["RJ", [["Card2", 2]]],
          ["Six", []],
        )
    end
  end
end
