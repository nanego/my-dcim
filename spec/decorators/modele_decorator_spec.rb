# frozen_string_literal: true

require "rails_helper"

RSpec.describe ModeleDecorator, type: :decorator do
  let(:modele) { modeles(:one) }
  let(:decorated_modele) { modele.decorated }

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

      it { is_expected.to be_nil }
    end

    context "when modele has one enclosure without a display set" do
      it { is_expected.to eq("-, -") }
    end

    context "when modele has one enclosure with a display set" do
      let(:modele) { modeles(:two) }

      it { is_expected.to eq("Horizontale") }
    end
  end
end
