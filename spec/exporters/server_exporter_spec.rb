# frozen_string_literal: true

require "rails_helper"

RSpec.describe ServerExporter do
  let(:exporter) { described_class.new(nil, []) }

  describe "default attribute names" do
    it { expect(described_class::DEFAULT_ATTRIBUTE_NAMES).to eq(%w[id created_at updated_at]) }
  end

  describe "#modele_category_id" do
    it { expect(exporter.modele_category_id(servers(:one))).to eq(1) }
  end

  describe "#islet_id" do
    it { expect(exporter.islet_id(servers(:one))).to eq(1) }
  end

  describe "#bay_id" do
    it { expect(exporter.bay_id(servers(:one))).to eq(1) }
  end

  describe "#u" do
    it { expect(exporter.u(servers(:one))).to eq(1) }
  end
end
