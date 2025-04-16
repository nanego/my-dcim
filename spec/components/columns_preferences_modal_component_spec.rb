# frozen_string_literal: true

require "rails_helper"

RSpec.describe ColumnsPreferencesModalComponent, type: :component do
  let(:component) { described_class.new("#", columns_preferences) }
  let(:rendered_component) { render_inline(component) }
  let(:columns_preferences) do
    ColumnsPreferences::Columns.new(
      model: Server,
      default: %w[id name],
      available: %w[id name numero],
      preferred: %w[id name]
    )
  end

  # it "renders something useful" do
  #   expect(
  #     render_inline(described_class.new(attr: "value")) { "Hello, components!" }.css("p").to_html
  #   ).to include(
  #     "Hello, components!"
  #   )
  # end
end
