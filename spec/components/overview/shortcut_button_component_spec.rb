# frozen_string_literal: true

require "rails_helper"

RSpec.describe Overview::ShortcutButtonComponent, type: :component do
  let(:id) { 1 }
  let(:position) { nil }
  let(:lane) { 1 }
  let(:component) { described_class.new(id, position, lane) }
  let(:rendered_component) { render_inline(component).to_html }

  describe "CreateBayButtonComponent" do
    it do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component).to have_tag("span.shortcut-button-component") do
        with_tag(
          "a.link-success",
          with: {
            href: "/bays/new?bay%5Bislet_id%5D=1&bay%5Blane%5D=1&bay%5Bposition%5D=&redirect_to_on_success=1",
            title: "Ajouter une baie",
            "data-controller": "tooltip",
          },
        ) do
          with_tag("span.bi.bi-plus-circle-fill")
        end

        without_tag("a.link-danger")
      end
    end
  end

  describe "CreateFrameDeleteBayButtonComponent" do
    let(:position) { 2 }
    let(:lane) { nil }

    it do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component).to have_tag("span.shortcut-button-component") do
        with_tag(
          "a.link-danger",
          with: {
            href: "/bays/1?redirect_to_on_success=back",
            title: "Supprimer la baie vide",
            "data-method": "delete",
            "data-confirm": "Êtes-vous sûr de vouloir supprimer cette baie ?",
            "data-controller": "tooltip",
          },
        ) do
          with_tag("span.bi.bi-dash-circle-fill")
        end

        with_tag(
          "a.link-success",
          with: {
            href: "/frames/new?frame%5Bbay_id%5D=1&frame%5Bposition%5D=2&redirect_to_on_success=1",
            title: "Ajouter un châssis",
            "data-controller": "tooltip",
          },
        ) do
          with_tag("span.bi.bi-plus-circle-fill")
        end
      end
    end
  end
end
