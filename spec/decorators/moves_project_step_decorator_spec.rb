# frozen_string_literal: true

require "rails_helper"

RSpec.describe MovesProjectStepDecorator, type: :decorator do
  describe ".grouped_by_project_options_for_select" do
    it do
      expect(described_class.grouped_by_project_options_for_select)
        .to have_tag("optgroup", with: { label: "A" }) do
          with_tag("option", with: { value: "1" }, text: "A")
        end
    end

    it do
      expect(described_class.grouped_by_project_options_for_select)
        .to have_tag("optgroup", with: { label: "B" }) do
          with_tag("option", with: { value: "2" }, text: "B")
        end
    end

    it do
      expect(described_class.grouped_by_project_options_for_select)
        .to have_tag("optgroup", with: { label: "C" }) do
          with_tag("option", with: { value: "3" }, text: "C")
        end
    end

    it do
      expect(described_class.grouped_by_project_options_for_select)
        .to have_tag("optgroup", with: { label: "D" }) do
          with_tag("option", with: { value: "4" }, text: "D")
        end
    end

    it do # rubocop:disable RSpec/ExampleLength
      expect(described_class.grouped_by_project_options_for_select)
        .to have_tag("optgroup", with: { label: "F" }) do
          with_tag("option", with: { value: "6" }, text: "Step 1")
          with_tag("option", with: { value: "7" }, text: "Step 2")
          with_tag("option", with: { value: "8" }, text: "Step 3")
        end
    end
  end
end
