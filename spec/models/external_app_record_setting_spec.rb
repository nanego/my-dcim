# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalAppRecordSetting do
  subject(:settings) { described_class.new(attributes) }

  let(:category) { Category.create!(id: 20, name: "name", description: "description", glpi_sync_type: :network_equipment) }
  let(:attributes) { {} }

  before { category }

  describe "#category_ids" do
    it { expect(settings.category_glpi_sync_types).to eq({ 1 => "server", 20 => "network_equipment" }) }
  end

  describe "#save" do
    let(:attributes) { { category_glpi_sync_types: { 20 => :server } } }

    it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      expect(categories(:one).glpi_sync_type_server?).to be(true)
      expect(category.glpi_sync_type_network_equipment?).to be(true)

      settings.save
      categories(:one).reload
      category.reload

      expect(categories(:one).glpi_sync_type_none?).to be(true)
      expect(category.glpi_sync_type_server?).to be(true)

      expect(described_class.new.category_glpi_sync_types).to eq({ 20 => "server" })
    end
  end
end
