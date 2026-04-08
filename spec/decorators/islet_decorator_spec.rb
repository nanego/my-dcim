# frozen_string_literal: true

require "rails_helper"

RSpec.describe IsletDecorator, type: :decorator do
  include Rails.application.routes.url_helpers

  let(:islet) { islets(:one) }
  let(:decorated_islet) { islet.decorated }
  let(:user) { users(:admin) }

  describe ".options_for_select" do
    it do
      expect(described_class.options_for_select(user))
        .to contain_exactly(["Ilot Islet1 S1", 1], ["Ilot Islet2 S1", 2], ["Ilot Islet3 S1", 3], ["Ilot Islet4 S6", 4], ["Ilot Islet5 S1", 5])
    end
  end

  describe ".sites_options_for_select" do
    it do
      expect(described_class.sites_options_for_select(user))
        .to contain_exactly(["Site 1", 1], ["Site 2", 2], ["Site 3", 3], ["Site 4", 4], ["Site 5", 5])
    end
  end

  describe ".rooms_options_for_select" do
    it do
      expect(described_class.rooms_options_for_select(user))
        .to contain_exactly(["Site 1 - S1", 1], ["Site 1 - S2", 2], ["Site 1 - S5", 5], ["Site 2 - S3", 3], ["Site 2 - S4", 4], ["Site 3 - S6", 6])
    end
  end

  describe ".grouped_by_sites_options_for_select" do
    let(:expected_response) do
      {
        "Site 1" => [["S1 Ilot Islet1", 1], ["S1 Ilot Islet2", 2]],
        "Site 3" => [["S6", 4]],
      }
    end

    it { expect(described_class.grouped_by_sites_options_for_select).to match(expected_response) }
  end

  describe ".cooling_modes_options_for_select" do
    it { expect(described_class.cooling_modes_options_for_select.pluck(1)).to match_array(Islet.cooling_modes.keys) }
  end

  describe ".access_control_options_for_select" do
    it { expect(described_class.access_control_options_for_select.pluck(1)).to match_array(Islet.access_controls.keys) }
  end

  describe "#full_name" do
    subject(:full_name) { decorated_islet.full_name }

    let(:islet) { Islet.new(name: "Islet1") }

    context "with name" do
      it { is_expected.to eq("Ilot Islet1") }
    end

    context "with empty name" do
      let(:islet) { Islet.new(name: "") }

      it { is_expected.to eq("Ilot") }
    end

    context "with nil name" do
      let(:islet) { Islet.new(name: nil) }

      it { is_expected.to eq("Ilot") }
    end
  end

  describe "#name_with_room" do
    subject(:name_with_room) { decorated_islet.name_with_room }

    it { is_expected.to eq("Ilot Islet1 S1") }
  end

  describe "#cooling_mode_to_human" do
    subject(:cooling_mode_sentence) { decorated_islet.cooling_mode_to_human }

    context "with no cooling mode" do
      it { is_expected.to eq("Pas de confinement") }
    end

    context "with cooling mode set" do
      before { islet.cooling_mode = "hot_containment" }

      it { is_expected.to eq("Confinement chaud") }
    end
  end

  describe "#access_control_to_human" do
    subject(:access_control_sentence) { decorated_islet.access_control_to_human }

    context "with no access control" do
      it { is_expected.to eq("Pas de contrôle") }
    end

    context "with access control set" do
      before { islet.access_control = "key" }

      it { is_expected.to eq("Clé") }
    end
  end

  describe "#overviewed_bays_array" do
    context "with admin user" do
      context "with one bay" do
        let(:islet) { islets(:two) }

        it { expect(decorated_islet.overviewed_bays_array(user)).to contain_exactly([1, [bays(:two)]]) }
      end

      context "with several bays on one lane and with one missing bay" do
        before { bays(:three).update(lane: 1, position: 4) }

        it do
          expect(decorated_islet.overviewed_bays_array(user)).to contain_exactly(
            [1, [bays(:one), :no_bay, bays(:five), bays(:three)]],
          )
        end
      end

      context "with several bays on two lanes and with missing bays" do
        before { bays(:three).update(lane: 2, position: 3) }

        it do
          expect(decorated_islet.overviewed_bays_array(user)).to contain_exactly(
            [1, [bays(:one), :no_bay, bays(:five)]], [2, [:no_bay, :no_bay, bays(:three)]],
          )
        end
      end
    end

    context "with reader user" do
      let(:user) { users(:reader) }

      context "with one bay not scopped" do
        let(:islet) { islets(:two) }

        it { expect(decorated_islet.overviewed_bays_array(user)).to be_empty }
      end

      context "with several bays on one lane and only one scopped (not first position)" do
        before { bays(:one).update(lane: 1, position: 3) }

        it do
          expect(decorated_islet.overviewed_bays_array(user)).to contain_exactly(
            [1, [bays(:one)]],
          )
        end
      end

      context "with one scopped bay" do
        it do
          expect(decorated_islet.overviewed_bays_array(user)).to contain_exactly(
            [1, [bays(:one)]],
          )
        end
      end
    end
  end
end
