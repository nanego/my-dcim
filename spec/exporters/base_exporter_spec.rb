# frozen_string_literal: true

require "rails_helper"

RSpec.describe BaseExporter do
  let(:exporter) { described_class.new(records, attributes) }
  let(:records) { [servers(:one)] }
  let(:attributes) { %i[numero position] }

  describe "#to_csv" do
    context "with valid attributes" do
      it do
        expected_csv = <<~CSV
          Id,#{Server.human_attribute_name(:created_at)},#{Server.human_attribute_name(:updated_at)},#{Server.human_attribute_name(:numero)},#{Server.human_attribute_name(:position)}
          1,#{servers(:one).created_at},#{servers(:one).updated_at},CZ31535FEY,39
        CSV

        expect(exporter.to_csv).to eq(expected_csv)
      end
    end

    context "with invalid attributes" do
      let(:attributes) { %i[numero undefined_attribute1234] }

      it { expect { exporter.to_csv }.to raise_error(BaseExporter::UndefinedAttributeExporter) }
    end

    context "with no records" do
      let(:records) { [] }

      it { expect(exporter.to_csv).to be_empty }
    end
  end
end
