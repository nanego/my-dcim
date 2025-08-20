# frozen_string_literal: true

require "rails_helper"

RSpec.describe CaptionComponent, type: :component do
  context "with html content" do
    let(:component) { described_class.new }
    let(:rendered_component) { render_inline(component, &block) }

    let(:block) do
      proc do
        "This is the main content"
      end
    end

    it "renders component" do
      expect(rendered_component.to_html).to have_tag("span.caption-component") do
        with_tag("span.caption-component-button")
        with_tag("span.caption-component-content", text: "This is the main content")
      end
    end
  end
end
