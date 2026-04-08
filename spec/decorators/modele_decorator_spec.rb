# frozen_string_literal: true

require "rails_helper"

RSpec.describe ModeleDecorator, type: :decorator do
  let(:modele) { modeles(:one) }
  let(:decorated_modele) { modele.decorated }

  describe ".manufacturers_options_for_select" do
    it do
      expect(described_class.manufacturers_options_for_select)
        .to contain_exactly(["Fourth", 4], ["Third", 3], ["fortinet", 1], ["juniper", 2])
    end
  end

  describe "#network_types_to_human" do
    subject(:network_types_sentence) { decorated_modele.network_types_to_human }

    context "when modele has no network type" do
      it { is_expected.to eq("Non (par défaut)") }
    end

    context "when modele has one network type" do
      before { modele.network_types = %w[gbe] }

      it { is_expected.to eq("Backbone Gbps") }
    end

    context "when modele has many network types" do
      before { modele.network_types = %w[10gbe fiber] }

      it { is_expected.to eq("Backbone 10Gbps, Backbone Fibre") }
    end
  end

  describe "#displays_to_human" do
    subject(:displays_to_human_sentence) { decorated_modele.displays_to_human }

    context "when modele has no enclosure" do
      let(:modele) { modeles(:four) }

      it { is_expected.to have_tag("span.fst-italic.fw-light.text-body-secondary", text: "Aucune enclosure") }
    end

    context "when modele has one enclosure" do
      let(:modele) { modeles(:two) }

      it { is_expected.to eq("Horizontale") }
    end

    context "when modele has several enclosures" do
      it { is_expected.to eq("Verticale, Verticale") }
    end
  end
end
