# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalAppRecordDecorator, type: :decorator do
  describe "#external_serial_to_badge_component" do
    subject(:badge) { ear.decorated.external_serial_to_badge_component }

    let(:ear) { external_app_records(:one) }

    context "with external_serial is not present" do
      it { is_expected.to be_a LabelComponent }
      it { expect(badge.instance_variable_get(:@type)).to eq :danger }
      it { expect(badge.content).to eq "NON TROUVÉ DANS GLPI" }
    end

    context "with external_serial is present" do
      before { ear.external_serial = "numero_serie" }

      it { is_expected.to be_a LabelComponent }
      it { expect(badge.instance_variable_get(:@type)).to eq :success }
      it { expect(badge.content).to eq "OK" }
    end
  end
end
