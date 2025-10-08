# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bay do
  # it_behaves_like "changelogable", new_attributes: { name: "New name" }

  subject(:bay) { bays(:one) }

  describe "associations" do
    it { is_expected.to belong_to(:bay_type) }
    it { is_expected.to belong_to(:islet) }
    it { is_expected.to belong_to(:manufacturer).optional }
    it { is_expected.to have_one(:room).through(:islet) }
    it { is_expected.to have_many(:frames) }
    it { is_expected.to have_many(:materials).through(:frames) }
  end

  describe "validations" do
    it { is_expected.to define_enum_for(:access_control).with_values(%i[badge key locken_key]) }
  end

  describe "position uniqueness validation" do
    let(:bay) { described_class.new(islet_id: 1, lane: 1, position: 1) }

    it { expect(bay.valid?).to be false }

    it :aggregate_failures do
      bay.validate

      expect(bay.errors.key?(:position)).to be(true)
      expect(bay.errors.where(:position, :taken).count).to eq(1)
    end
  end

  describe "#to_s" do
    context "with frames" do
      let(:bay) { bays(:one) }

      it { expect(bay.to_s).to eq "MyFrame1 / MyFrame2" }
    end

    context "without frames" do
      let(:bay) { bays(:five) }

      it { expect(bay.to_s).to eq "Baie vide" }
    end
  end

  describe "#detailed_name" do
    pending
  end

  describe "#list_frames" do
    context "with two frames" do
      let(:bay) { bays(:one) }

      it { expect(bay.list_frames).to eq "MyFrame1 / MyFrame2" }
    end

    context "with one frame" do
      let(:bay) { bays(:four) }

      it { expect(bay.list_frames).to eq "MyFrame5" }
    end

    context "without frames" do
      let(:bay) { bays(:five) }

      it { expect(bay.list_frames).to be_empty }
    end
  end

  describe "#last_position_used" do
    it { expect(bay.last_position_used).to eq 3 }
  end

  describe "#next_free_position" do
    it { expect(bay.next_free_position).to eq 4 }
  end

  describe "#set_position" do
    let(:bay) { described_class.new(islet_id: 1, lane: 1, position:, bay_type: bay_types(:one)) }
    let(:position) { nil }

    before { bay.save }

    context "with position is nil" do
      it { expect(bay.position).to eq 4 }
    end

    context "with position is not nil" do
      let(:position) { 8 }

      it { expect(bay.position).to eq 8 }
    end
  end
end
