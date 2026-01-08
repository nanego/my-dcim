# frozen_string_literal: true

require "rails_helper"

RSpec.describe ServerDecorator, type: :decorator do
  let(:server) { servers(:one) }
  let(:decorated_server) { server.decorated }
  let(:user) { users(:admin) }

  describe ".options_for_select" do
    it do
      expect(described_class.options_for_select(user))
        .to contain_exactly(
          ["ServerName1", 1], ["ServerName2", 2], ["ServerName3", 740_841_338], ["ServerName4", 4],
          ["ServerName5", 5], ["ServerName6", 6], ["ReadableServer", 8],
        )
    end
  end

  describe ".rooms_options_for_select" do
    it do
      expect(described_class.rooms_options_for_select(user))
        .to contain_exactly(
          ["Site 1 - S1", 1], ["Site 1 - S2", 2], ["Site 1 - S5", 5], ["Site 2 - S3", 3], ["Site 2 - S4", 4],
          ["Site 3 - S6", 6],
        )
    end
  end

  describe ".islets_options_for_select" do
    it do
      expect(described_class.islets_options_for_select(user))
        .to contain_exactly(
          ["Ilot Islet1 S1", 1], ["Ilot Islet2 S1", 2], ["Ilot Islet3 S1", 3], ["Ilot Islet4 S6", 4],
          ["Ilot Islet5 S1", 5],
        )
    end
  end

  describe ".bays_options_for_select" do
    it do
      expect(described_class.bays_options_for_select(user))
        .to contain_exactly(
          ["Baie vide", 3], ["Baie vide", 5], ["MyFrame1 / MyFrame2", 1], ["MyFrame3 / MyFrame4", 2], ["MyFrame5", 4],
        )
    end
  end

  describe ".frames_options_for_select" do
    it do
      expect(described_class.frames_options_for_select(user))
        .to contain_exactly(["MyFrame1", 1], ["MyFrame2", 2], ["MyFrame3", 3], ["MyFrame4", 4], ["MyFrame5", 5])
    end
  end

  describe ".domains_options_for_select" do
    it do
      expect(described_class.domains_options_for_select(user))
        .to contain_exactly(["Empty domain", 4], ["Empty domain 2", 5], ["Stock", 2], ["Switch", 1], ["Three", 3])
    end
  end

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
