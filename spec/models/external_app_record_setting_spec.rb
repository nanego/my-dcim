# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalAppRecordSetting do
  subject(:settings) { described_class.new(attributes) }

  let(:category) { Category.create!(id: 20, name: "name", description: "description", glpi_sync: :network_equipment) }
  let(:attributes) { {} }

  before { category }

  describe "#category_ids" do
    it { expect(settings.category_glpi_syncs).to eq({ 1 => "server", 20 => "network_equipment" }) }
  end

  describe "#save" do
    let(:attributes) { { category_glpi_syncs: { 20 => :server } } }

    it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      expect(categories(:one).server_glpi_sync?).to be(true)
      expect(category.network_equipment_glpi_sync?).to be(true)

      settings.save
      categories(:one).reload
      category.reload

      expect(categories(:one).no_glpi_sync?).to be(true)
      expect(category.server_glpi_sync?).to be(true)

      expect(described_class.new.category_glpi_syncs).to eq({ 20 => "server" })
    end
  end
end
