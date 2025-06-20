# frozen_string_literal: true

require "rails_helper"

RSpec.describe CardEmptyDataComponent, type: :component do
  let(:component) { described_class.new }
  let(:rendered_component) { render_inline(component) }

  context "with default icon" do
    it "renders the component" do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component.to_html).to have_tag("div", class: "card text-center text-secondary-emphasis") do
        with_tag("div", class: "card-body") do
          with_tag("span", class: "bi bi-table fs-1 text-secondary text-opacity-25")
          with_tag("h5", class: "card-title mt-3", text: "Aucune donnée trouvée")
        end
      end
    end
  end

  context "with manually set icon" do
    let(:component) { described_class.new(icon: "eye") }

    it "renders the component" do
      expect(rendered_component.to_html).to have_tag("div", class: "card text-center text-secondary-emphasis") do
        with_tag("div", class: "card-body") do
          with_tag("span", class: "bi bi-eye fs-1 text-secondary text-opacity-25")
        end
      end
    end
  end
end
