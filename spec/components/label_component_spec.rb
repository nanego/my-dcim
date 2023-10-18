# frozen_string_literal: true

require "rails_helper"

RSpec.describe LabelComponent, type: :component do
  context "with html content" do
    let(:component) { described_class.new(text, **kwargs) }
    let(:rendered_component) { render_inline(component, &block) }
    let(:text) { "Text as argument" }
    let(:kwargs) { {} }
    let(:block) {}

    context "with text" do
      it { expect(rendered_component.to_html).to have_tag("span.label.label-default", text: /Text as argument/) }
    end

    context "with text as block" do
      let(:block) { proc { "Text as block" } }

      it { expect(rendered_component.to_html).to have_tag("span.label.label-default", text: /Text as block/) }
    end

    context "with type" do
      let(:kwargs) { { type: :success } }

      it { expect(rendered_component.to_html).to have_tag("span.label.label-success", text: /Text as argument/) }
    end
  end
end
