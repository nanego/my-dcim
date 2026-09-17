# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnitCardDecorator, type: :decorator do
  describe ".card_type_grouped_by_port_type_options_for_select" do
    it do
      expect(described_class.card_type_grouped_by_port_type_options_for_select)
        .to have_tag("optgroup", with: { label: "ALIM" }) do
          with_tag("option", with: { value: "6" }, text: "Card6")
        end
    end

    it "marks the given option as selected" do
      expect(described_class.card_type_grouped_by_port_type_options_for_select(6))
        .to have_tag("option", with: { value: "6", selected: "selected" })
    end
  end
end
