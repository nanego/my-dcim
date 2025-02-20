# frozen_string_literal: true

require "rails_helper"

RSpec.describe LabelComponent, type: :component do
  context "with html content" do
    let(:component) { described_class.new(text, **kwargs) }
    let(:rendered_component) { render_inline(component, &block) }
    let(:text) { "Text as argument" }
    let(:kwargs) { {} }
    let(:block) { nil }

    context "with text" do
      it do
        expect(rendered_component.to_html).to have_tag(
          "span.text-default-emphasis.bg-default-subtle.border.border-default-subtle",
          text: /Text as argument/
        )
      end
    end

    context "with text as block" do
      let(:block) { proc { "Text as block" } }

      it do
        expect(rendered_component.to_html).to have_tag(
          "span.text-default-emphasis.bg-default-subtle.border.border-default-subtle",
          text: /Text as block/
        )
      end
    end

    context "with type" do
      let(:kwargs) { { type: :success } }

      it do
        expect(rendered_component.to_html).to have_tag(
          "span.text-success-emphasis.bg-success-subtle.border.border-success-subtle",
          text: /Text as argument/
        )
      end
    end

    context "with not valid type" do
      let(:kwargs) { { type: :unknow } }

      it { expect { component }.to raise_error(ArgumentError) }
    end
  end
end
