# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProcessorFilter do
  subject(:filter) do
    described_class.new(records, params, with: with)
  end

  let(:records) { Cluster.all }
  let(:params)  { ActionController::Parameters.new({}) }
  let(:with)    { nil }

  describe "#results" do
    it { expect(filter.results.size).to eq(2) }
  end

  describe "#filled?" do
    it { expect(filter.filled?).to be(false) }

    context "with params" do
      let(:params) { ActionController::Parameters.new({ q: "test" }) }

      it { expect(filter.filled?).to be(true) }
    end
  end

  describe "#filled_attributes" do
    it { expect(filter.filled_attributes).to be_empty }

    context "with params" do
      let(:params) { ActionController::Parameters.new({ q: "test" }) }

      it { expect(filter.filled_attributes).to eq({ "q" => "test" }) }
    end
  end

  describe "#attributes" do
    it { expect(filter.attributes).to eq({}) }

    context "with params" do
      let(:params) { ActionController::Parameters.new({ q: "cl" }) }

      it { expect(filter.attributes).to eq({ "q" => "cl" }) }
    end
  end

  describe "#attribute_names" do
    it { expect(filter.attribute_names).to eq(%i[q sort_by sort]) }
  end

  describe "#total_count" do
    it { expect(filter.total_count).to eq(2) }
  end

  describe "#results_count" do
    it { expect(filter.results_count).to eq(2) }
  end
end
