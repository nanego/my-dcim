# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalAppRecordDecorator, type: :decorator do
  describe ".external_serial_status_options_for_select" do
    it do
      expect(described_class.external_serial_status_options_for_select.pluck(1)).to \
        match_array(ExternalAppRecord::EXTERNAL_SERIAL_STATUSES)
    end
  end

  describe "#external_serial_to_badge_component" do
    subject(:badge) { ear.decorated.external_serial_to_badge_component }

    let(:ear) { external_app_records(:one) }

    context "with external_serial is not present" do
      it { is_expected.to be_a BadgeComponent }
      it { expect(badge.instance_variable_get(:@color)).to eq :danger }
      it { expect(badge.content).to eq "NON TROUVÉ DANS GLPI" }
    end

    context "with external_serial is present" do
      before { ear.external_serial = "numero_serie" }

      it { is_expected.to be_a BadgeComponent }
      it { expect(badge.instance_variable_get(:@color)).to eq :success }
      it { expect(badge.content).to eq "TROUVÉ" }
    end
  end
end
