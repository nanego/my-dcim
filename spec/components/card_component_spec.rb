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

    it do
      expect(rendered_component.to_html)
        .to have_tag("div.card > div.card-header", text: /Text as header/)
    end
  end

  context "with body" do
    let(:block) do
      proc do |card|
        card.with_body(extra_classes: "p-0") { "Text as body" }
      end
    end

    it do
      expect(rendered_component.to_html)
        .to have_tag("div.card > div.card-body.p-0", text: /Text as body/)
    end
  end

  context "with footer" do
    let(:block) do
      proc do |card|
        card.with_footer { "Text as footer" }
      end
    end

    it do
      expect(rendered_component.to_html)
        .to have_tag("div.card > div.card-footer", text: /Text as footer/)
    end
  end

  context "with valid type" do
    let(:component) { described_class.new(type: :primary) }

    it { expect(rendered_component.to_html).to have_css("div.card.border-primary") }
  end

  context "with invalid type" do
    let(:component) { described_class.new(type: :unknown) }

    it { expect { component }.to raise_error(ArgumentError) }
  end

  context "with an extra_class" do
    let(:component) { described_class.new(extra_classes: "test") }

    it { expect(rendered_component.to_html).to have_css("div.card.test") }
  end

  context "with html attributes" do
    let(:component) { described_class.new(data: { key: :value }, id: "custom") }

    it { expect(rendered_component.to_html).to have_css("div.card#custom[data-key=value]") }
  end
end
