# frozen_string_literal: true

require "rails_helper"

RSpec.describe HasManyTurboFrameComponent, type: :component do
  include Rails.application.routes.url_helpers

  let(:islet) { islets(:one) }
  let(:url)   { bays_path(islet_id: islet.id) }
  let(:component) { described_class.new("Title", url:, frame_id: :table_islet) }
  let(:rendered_component) { render_inline(component) }

  context "with object" do
    it "renders component" do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component.to_html).to have_tag("turbo-frame", with: {
        id: "table_islet",
        src: url
      }) do
        with_text("Chargement en cours ...")
        with_tag("span", with: { class: "spinner-grow" })
      end
    end
  end

  context "with html attributes" do
    let(:component) do
      described_class.new("Title", url:, frame_id: :table_islet, id: "custom", type: :secondary, data: { key: :value })
    end

    it { expect(rendered_component.to_html).to have_css("div#custom.card.border-secondary.bg-body-tertiary[data-key=value]") }
  end
end
