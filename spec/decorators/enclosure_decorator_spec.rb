# frozen_string_literal: true

require "rails_helper"

describe EnclosureDecorator, type: :decorator do
  let(:object) { enclosures(:one) }
  let(:decorated_user) { described_class.new(object) }

  describe "#display_name" do
    it { expect(decorated_user.display_name).to eq("Enclosure 1 (compo1, compo2 et SL3)") }

    context "without composants" do
      let(:object) { Enclosure.new(position: 1) }

      it { expect(decorated_user.display_name).to eq("Enclosure 1 (0 composant)") }
    end

    context "with composant with empty name" do
      let(:object) { Enclosure.new(position: 1) }

      before { allow(object).to receive(:composants).and_return([Composant.new]) }

      it { expect(decorated_user.display_name).to eq("Enclosure 1 (n/c)") }
    end
  end
end
