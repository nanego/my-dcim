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

    it do
      expect(rendered_component).to have_tag("div.col-12.sticky-bottom") do
        with_tag("a", href: "/islets", text: "Annuler")
        with_tag("a", text: "Annuler", count: 1)
        with_tag("input.btn-success", type: "submit", value: "Créer")
        without_tag("input.btn-info", type: "submit", value: "Modifier")
      end
    end
  end

  context "with persisted object" do
    let(:object) { islets(:one) }

    it { expect(rendered_component).not_to be_nil }

    it do
      expect(rendered_component).to have_tag("div.col-12.sticky-bottom") do
        with_tag("a", href: "/islets/1", text: "Annuler")
        with_tag("a", text: "Annuler", count: 1)
        without_tag("input.btn-success", type: "submit", value: "Créer")
        with_tag("input.btn-info", type: "submit", value: "Modifier")
      end
    end
  end
end
