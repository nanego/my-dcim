# frozen_string_literal: true

require "rails_helper"

RSpec.describe CardEmptyDataComponent, type: :component do
  let(:component) { described_class.new }
  let(:rendered_component) { render_inline(component) }

  context "with default icon and text" do
    it "renders the component" do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component.to_html).to have_tag("div", with: { class: "card text-center text-secondary-emphasis" }) do
        with_tag("div", with: { class: nil }) do
          with_tag("span", with: { class: "bi bi-slash-circle fs-1 text-secondary text-opacity-25" })
          with_tag("h5", text: "Aucune donnée trouvée", with: { class: "card-title mt-3" })
        end
      end
    end
  end

  context "with manually set icon and text" do
    let(:component) { described_class.new(icon: :table, text: "Texte alternatif") }

    it "renders the component" do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component.to_html).to have_tag("div", with: { class: "card text-center text-secondary-emphasis" }) do
        with_tag("div", with: { class: "card-body" }) do
          with_tag("span", with: { class: "bi bi-table fs-1 text-secondary text-opacity-25" })
          with_tag("h5", text: "Texte alternatif", with: { class: "card-title mt-3" })
        end
      end
    end
  end
end
