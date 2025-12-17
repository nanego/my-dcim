# frozen_string_literal: true

require "rails_helper"

RSpec.describe Frame do
  # it_behaves_like "changelogable", object: -> { described_class.new(bay: Bay.create!) },
  #                                  new_attributes: { name: "New name" }

  subject(:frame) { frames(:one) }

  describe "associations" do
    it { is_expected.to belong_to(:bay) }

    it { is_expected.to have_one(:islet).through(:bay) }
    it { is_expected.to have_one(:room).through(:islet) }

    it { is_expected.to have_many(:materials) }
    it { is_expected.to have_many(:pdus) }
    it { is_expected.to have_many(:servers) }
    it { is_expected.to have_many(:target_moves) }
    it { is_expected.to have_many(:origin_moves) }
  end

  describe "validations" do
    it { is_expected.to be_valid }
    it { is_expected.to validate_uniqueness_of(:position).scoped_to(:bay_id) }
  end

  describe "#to_s" do
    it { expect(frame.to_s).to eq "MyFrame1" }
  end

  describe ".all_sorted" do
    pending
  end

  describe "#should_generate_new_friendly_id?" do
    pending
  end

  describe "#name_with_room_and_islet" do
    it { expect(frame.name_with_room_and_islet).to eq "Salle S1 Ilot Islet1 Châssis MyFrame1" }
  end

  describe ".to_txt" do
    pending
  end

  describe "#to_txt" do
    pending
  end

  describe "#other_frame" do
    pending
  end

  describe "#other_frames" do
    pending
  end

  describe "#has_coupled_frame?" do
    it { expect(frame.has_coupled_frame?).to be true }
    it { expect(frames(:five).has_coupled_frame?).to be false }
  end

  describe "#has_no_coupled_frame?" do
    it { expect(frame.has_no_coupled_frame?).to be false }
    it { expect(frames(:five).has_no_coupled_frame?).to be true }
  end

  describe "#compact_u" do
    pending
  end

  describe "#init_pdus" do
    pending
  end

  describe "#last_position_used" do
    it { expect(frame.send(:last_position_used)).to eq 2 }
  end

  describe "#next_free_position" do
    it { expect(frame.send(:next_free_position)).to eq 3 }
  end

  describe "#set_position" do
    let(:frame) { described_class.new(bay_id: 1, position:) }
    let(:position) { nil }

    before { frame.save }

    context "with position is nil" do
      it { expect(frame.position).to eq 3 }
    end

    context "with position is not nil" do
      let(:position) { 8 }

      it { expect(frame.position).to eq 8 }
    end
  end
end
