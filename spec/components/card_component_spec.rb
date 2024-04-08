# frozen_string_literal: true

require "rails_helper"

RSpec.describe CardComponent, type: :component do
  let(:component) { described_class.new }
  let(:rendered_component) { render_inline(component, &block) }
  let(:block) do
    proc do
      "Text as content"
    end
  end

  context "with content" do
    it { expect(rendered_component.to_html).to have_text("Text as content") }
  end

  context "with header" do
    let(:block) do
      proc do |card|
        card.with_header { "Text as header" }
      end
    end

    it { expect(rendered_component.to_html).to have_text("Text as header") }
  end

  context "with footer" do
    let(:block) do
      proc do |card|
        card.with_footer { "Text as footer" }
      end
    end

    it { expect(rendered_component.to_html).to have_text("Text as footer") }
  end
end
