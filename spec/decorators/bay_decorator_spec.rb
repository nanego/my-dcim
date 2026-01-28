# frozen_string_literal: true

require "rails_helper"

RSpec.describe BayDecorator, type: :decorator do
  include Rails.application.routes.url_helpers

  let(:bay) { bays(:one) }
  let(:decorated_bay) { bay.decorated }
  let(:user) { users(:admin) }

  describe ".options_for_select" do
    it do
      expect(described_class.options_for_select(user))
        .to contain_exactly(["Baie vide", 3], ["Baie vide", 5], ["MyFrame1 / MyFrame2", 1], ["MyFrame3 / MyFrame4", 2], ["MyFrame5", 4])
    end
  end

  describe ".rooms_options_for_select" do
    it do
      expect(described_class.rooms_options_for_select(user))
        .to contain_exactly(["Site 1 - S1", 1], ["Site 1 - S2", 2], ["Site 1 - S5", 5], ["Site 2 - S3", 3], ["Site 2 - S4", 4], ["Site 3 - S6", 6])
    end
  end

  describe ".islets_options_for_select" do
    it do
      expect(described_class.islets_options_for_select(user))
        .to contain_exactly(["Ilot Islet1 S1", 1], ["Ilot Islet2 S1", 2], ["Ilot Islet3 S1", 3], ["Ilot Islet4 S6", 4], ["Ilot Islet5 S1", 5])
    end
  end

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

    it do
      is_expected.to have_tag("span.bay-with-no-frame-warning") do # rubocop:disable RSpec/ImplicitSubject
        with_tag("span.text-warning")
        with_tag("span.visually-hidden", text: "Veuillez renseigner un châssis à cette baie")
      end
    end
  end
end
