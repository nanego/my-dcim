# frozen_string_literal: true

require "rails_helper"

RSpec.describe BayDecorator, type: :decorator do
  let(:bay) { bays(:one) }
  let(:decorated_bay) { bay.decorated }

  describe ".access_control_options_for_select" do
    it { expect(described_class.access_control_options_for_select.pluck(1)).to match_array(Islet.access_controls.keys) }
  end

  describe "#access_control_to_human" do
    subject(:access_control_sentence) { decorated_bay.access_control_to_human }

    context "with no access control" do
      it { is_expected.to eq("Pas de contrôle") }
    end

    context "with access control set" do
      before { bay.access_control = "locken_key" }

      it { is_expected.to eq("Clé Locken") }
    end
  end
  
  describe "#no_frame_warning_icon" do
    subject(:warning_icon) { decorated_bay.no_frame_warning_icon }

    it { is_expected.to include("<span class=\"bay-with-no-frame-warning").once }
    it { is_expected.to include("<i class=\"bi bi-exclamation-triangle-fill").once }
    it { is_expected.to include("<span class=\"visually-hidden").once }
  end
end
