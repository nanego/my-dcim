# frozen_string_literal: true

require "rails_helper"

RSpec.describe Filter do
  subject(:filter) do
    described_class.new(records, params, with: with)
  end

  let(:records) { Cluster.all }
  let(:params)  { ActionController::Parameters.new({}) }
  let(:with)    { nil }

  describe "#results" do
    it { expect(filter.results.size).to eq(2) }
  end

  describe "#fill?" do
    it { expect(filter.fill?).to be(false) }

    context "with params" do
      let(:params) { ActionController::Parameters.new({ name: "test" }) }

      it { expect(filter.fill?).to be(true) }
    end
  end

  describe "#attributes" do
    it { expect(filter.attributes).to eq({}) }

    context "with params" do
      let(:params) { ActionController::Parameters.new({ name: "cl" }) }

      it { expect(filter.attributes).to eq({ "name" => "cl" }) }
    end
  end

  describe "#attribute_names" do
    it { expect(filter.attribute_names).to eq(%i[name]) }
  end

  describe "#model_name" do
    it { expect(filter.model_name).to be_a(Filter::Name) }
    it { expect(filter.model_name).to be_a(ActiveModel::Name) }
  end

  describe "#method_missing" do
    it { expect(filter.name).to be_nil }

    context "with params" do
      let(:params) { ActionController::Parameters.new({ name: "cl" }) }

      it { expect(filter.name).to eq("cl") }
    end
  end
end
