# frozen_string_literal: true

require "rails_helper"

RSpec.describe ColumnsPreferencesDropdownComponent, type: :component do
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

  it "renders button" do
    expect(rendered_component.to_html).to have_button(text: t("columns_preferences_modal_component.trigger_modal"))
  end
end
