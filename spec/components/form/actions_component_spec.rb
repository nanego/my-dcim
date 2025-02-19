# frozen_string_literal: true

require "rails_helper"

RSpec.describe Form::ActionsComponent, type: :component do
  let(:component) { described_class.new(form) }
  let(:rendered_component) { render_inline(component, &block).to_html }
  let(:object) { Islet.new }
  let(:form) { form_with(object) }
  let(:block) { nil }

  before { object.validate }

  context "with new object" do
    it { expect(rendered_component).not_to be_nil }

    it do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component).to have_tag("div.col-12.sticky-bottom") do
        with_tag("a", href: "/islets", text: I18n.t("action.cancel"))
        with_tag("a", text: I18n.t("action.cancel"), count: 1)
        with_tag("input.btn-success", type: "submit", value: I18n.t("action.create"))
        without_tag("input.btn-info", type: "submit", value: I18n.t("action.edit"))
      end
    end
  end

  context "with persisted object" do
    let(:object) { islets(:one) }

    it { expect(rendered_component).not_to be_nil }

    it do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component).to have_tag("div.col-12.sticky-bottom") do
        with_tag("a", href: "/islets/1", text: I18n.t("action.cancel"))
        with_tag("a", text: I18n.t("action.cancel"), count: 1)
        without_tag("input.btn-success", type: "submit", value: I18n.t("action.create"))
        with_tag("input.btn-info", type: "submit", value: I18n.t("action.edit"))
      end
    end
  end
end
