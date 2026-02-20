# frozen_string_literal: true

require "rails_helper"

RSpec.describe CategoryDecorator, type: :decorator do
  let(:object) { categories(:one) }
  let(:decorated_category) { described_class.decorate(object) }

  describe "#glpi_sync_human" do
    it do
      expect(decorated_category.glpi_sync_human).to eq(Category.human_attribute_name(:server_glpi_sync))
    end
  end

  describe ".glpi_sync_human_for" do
    it do
      expect(described_class.glpi_sync_human_for(:no)).to eq(Category.human_attribute_name(:no_glpi_sync))
    end
  end

  describe ".glpi_sync_options_for_select" do
    it do
      expect(described_class.glpi_sync_options_for_select).to eq(
        %i[no server network_equipment].map do |s|
          [Category.human_attribute_name("#{s}_glpi_sync"), s.to_s]
        end,
      )
    end
  end
end
