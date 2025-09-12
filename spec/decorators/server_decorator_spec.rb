# frozen_string_literal: true

require "rails_helper"

RSpec.describe ServerDecorator, type: :decorator do
  let(:server) { servers(:one) }
  let(:decorated_server) { server.decorated }

  describe "#network_types_to_human" do
    subject(:network_types_sentence) { decorated_server.network_types_to_human }

    context "when server has no network type" do
      it { is_expected.to eq("Non (par défaut)") }
    end

    context "when server has one network type" do
      before { server.network_types = %w[gbe] }

      it { is_expected.to eq("Backbone Gbps") }
    end

    context "when server has many network types" do
      before { server.network_types = %w[10gbe fiber] }

      it { is_expected.to eq("Backbone 10Gbps, Backbone Fibre") }
    end
  end

  describe "#full_name" do
    it { expect(decorated_server.full_name).to eq("MyString ServerName1") }

    context "when server has no model" do
      before { server.modele = nil }

      it { expect(decorated_server.full_name).to eq("ServerName1") }
    end
  end
end
