# frozen_string_literal: true

require "rails_helper"

RSpec.describe CategoryDecorator, type: :decorator do
  let(:object) { categories(:one) }
  let(:decorated_category) { described_class.decorate(object) }

  describe ".glpi_sync_type_options_for_select" do
    it do
      expect(described_class.glpi_sync_type_options_for_select).to eq(
        [["Aucun", "none"], ["Serveur", "server"], ["Équipement réseau", "network_equipment"]],
      )
    end
  end

  describe ".glpi_sync_type_human_for" do
    it do
      expect(described_class.glpi_sync_type_human_for(:no)).to eq(Category.human_attribute_name("glpi_sync_type.no"))
    end
  end

  describe "#glpi_sync_type_human" do
    it do
      expect(decorated_category.glpi_sync_type_human).to eq(Category.human_attribute_name("glpi_sync_type.server"))
    end

    context "with glpi_sync_type is equal to no" do
      before { object.glpi_sync_type = "none" }

      it do
        expect(decorated_category.glpi_sync_type_human)
          .to have_tag("span.fst-italic.fw-light.text-body-secondary", text: "n/c")
      end
    end
  end
end
