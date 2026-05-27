# frozen_string_literal: true

require "rails_helper"

RSpec.describe CardTypeDecorator, type: :decorator do
  let(:card_type) { card_types(:one) }
  let(:decorated_card_type) { card_type.decorated }

  describe ".grouped_by_port_type_options_for_select" do
    it do
      expect(described_class.grouped_by_port_type_options_for_select)
        .to have_tag("optgroup", with: { label: "FC" }) do
          with_tag("option", with: { value: "3" }, text: "Card3")
        end
    end

    it do
      expect(described_class.grouped_by_port_type_options_for_select)
        .to have_tag("optgroup", with: { label: "RJ" }) do
          with_tag("option", with: { value: "2" }, text: "Card2")
        end
    end

    it do # rubocop:disable RSpec/ExampleLength
      expect(described_class.grouped_by_port_type_options_for_select)
        .to have_tag("optgroup", with: { label: "IPMI" }) do
          with_tag("option", with: { value: "1" }, text: "Card1")
          with_tag("option", with: { value: "4" }, text: "6ALIM")
          with_tag("option", with: { value: "5" }, text: "Card5")
        end
    end
  end
end
