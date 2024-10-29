# frozen_string_literal: true

require "rails_helper"

RSpec.describe HasManyTurboFrameComponent, type: :component do
  include Rails.application.routes.url_helpers

  context "with object" do
    let(:islet) { islets(:one) }
    let(:url)   { bays_path(islet_id: islet.id) }
    let(:component) { described_class.new("Title", url:, frame_id: :table_islet) }
    let(:rendered_component) { render_inline(component) }

    it "renders component" do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component.to_html).to have_tag("turbo-frame", with: {
        id: "table_islet",
        src: url
      }) do
        with_text(I18n.t("has_many_turbo_frame_component.loading"))
        with_tag("span", with: { class: "spinner-grow" })
      end
    end
  end
end
