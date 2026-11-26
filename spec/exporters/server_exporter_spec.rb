# frozen_string_literal: true

require "rails_helper"

RSpec.describe ServerExporter do
  let(:exporter) { described_class.new(records, attributes) }
  let(:records) { [servers(:one)] }
  let(:attributes) { %i[numero position] }

  describe "#to_csv" do
    context "with valid attributes" do
      it do
        expect(exporter.to_csv).to eq <<~CSV
          Id,#{Server.human_attribute_name(:created_at)},#{Server.human_attribute_name(:updated_at)},#{Server.human_attribute_name(:numero)},#{Server.human_attribute_name(:position)}
          #{servers(:one).id},#{servers(:one).created_at},#{servers(:one).updated_at},#{servers(:one).numero},#{servers(:one).position}
        CSV
      end
    end

    context "with invalid attributes" do
      let(:attributes) { %i[numero undefined_attribute1234] }

      it { expect { exporter.to_csv }.to raise_error(BaseExporter::UndefinedAttributeError) }
    end

    context "with every column available on the servers index" do
      let(:attributes) { ServersController::AVAILABLE_COLUMNS }

      it { expect { exporter.to_csv }.not_to raise_error }
    end

    context "with no records" do
      let(:records) { [] }

      it do
        expect(exporter.to_csv).to eq <<~CSV
          Id,#{Server.human_attribute_name(:created_at)},#{Server.human_attribute_name(:updated_at)},#{Server.human_attribute_name(:numero)},#{Server.human_attribute_name(:position)}
        CSV
      end
    end
  end

  describe "#modele_category_id" do
    it { expect(exporter.modele_category_id(servers(:one))).to eq("MyString") }
  end

  describe "#room_id" do
    it { expect(exporter.room_id(servers(:one))).to eq("S1") }
  end

  describe "#islet_id" do
    it { expect(exporter.islet_id(servers(:one))).to eq("Islet1") }
  end

  describe "#bay_id" do
    it { expect(exporter.bay_id(servers(:one))).to eq("MyFrame1 / MyFrame2") }
  end

  describe "#u" do
    it { expect(exporter.u(servers(:one))).to eq(1) }
  end
end
