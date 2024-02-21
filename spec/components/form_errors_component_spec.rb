# frozen_string_literal: true

require "rails_helper"

RSpec.describe FormErrorsComponent, type: :component do
  let(:component) { described_class.new(object) }
  let(:rendered_component) { render_inline(component, &block) }
  let(:object) { Islet.new }
  let(:block) { nil }

  before { object.validate }

  context "with errors" do
    it { expect(rendered_component.to_html).not_to be_nil }
    it { expect(rendered_component.to_html).to include(I18n.t("form_errors_component.title.one")) }
    it { expect(rendered_component.to_html).to have_tag("li") }
  end

  context "with no errors" do
    let(:object) { Color.new }

    it { expect(rendered_component.to_html).to eq "" }
  end
end
