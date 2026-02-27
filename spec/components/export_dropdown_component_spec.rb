# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExportDropdownComponent, type: :component do
  let(:component) { described_class.new(url: :root_path, pagy:, param: :filter) }
  let(:rendered_component) { render_inline(component) }
  let(:pagy) { Pagy.new(count: 101, vars: { page_param: :page }) }

  context "with next page" do
    it "renders the component" do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component.to_html).to have_tag("div.dropdown") do
        with_tag("ul.dropdown-menu") do
          with_tag("a", count: 1, with: { href: "/?format=csv&param=filter" })
          with_tag("a", count: 1, with: { href: "/?format=csv&page=1&param=filter" })
        end
      end
    end
  end

  context "with no next page" do
    let(:pagy) { Pagy.new(count: 10, vars: { page_param: :page }) }

    it "renders the component" do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component.to_html).to have_tag("div.dropdown") do
        with_tag("ul.dropdown-menu") do
          with_tag("a", count: 1, with: { href: "/?format=csv&param=filter" })
          without_tag("a", with: { href: "/?format=csv&page=1&param=filter" })
        end
      end
    end
  end
end
