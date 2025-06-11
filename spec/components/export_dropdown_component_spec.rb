# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExportDropdownComponent, type: :component do
  let(:component) { described_class.new(url: "basic_url", page_url: "page_url") }
  let(:rendered_component) { render_inline(component) }

  it "renders the component" do # rubocop:disable RSpec/ExampleLength
    expect(rendered_component.to_html).to have_tag("div.dropdown") do
      with_tag("ul.dropdown-menu") do
        with_tag("a[href=\"page_url\"]", count: 1)
        with_tag("a[href=\"basic_url\"]", count: 1)
      end
    end
  end
end
