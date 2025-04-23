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

  it "renders the component" do # rubocop:disable RSpec/ExampleLength
    expect(rendered_component.to_html).to have_tag("div.dropdown") do
      with_tag('form[action="#"]', count: 2)

      columns_preferences.available do |column|
        with_tag("input[type=\"checkbox\"][id=#{column}_id]")
      end
    end
  end
end
