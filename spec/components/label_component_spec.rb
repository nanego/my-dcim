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
      it { expect(rendered_component.to_html).to have_tag("span.badge.text-bg-default", text: /Text as argument/) }
    end

    context "with text as block" do
      let(:block) { proc { "Text as block" } }

      it { expect(rendered_component.to_html).to have_tag("span.badge.text-bg-default", text: /Text as block/) }
    end

    context "with type" do
      let(:kwargs) { { type: :success } }

      it { expect(rendered_component.to_html).to have_tag("span.badge.text-bg-success", text: /Text as argument/) }
    end

    context "with not valid type" do
      let(:kwargs) { { type: :unknow } }

      it { expect { component }.to raise_error(ArgumentError) }
    end
  end
end
