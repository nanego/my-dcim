# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:room) { Room.create(name: "Petite salle") }

  describe "associations" do
    it { is_expected.to belong_to(:site) }
    it { is_expected.to have_many(:islets) }
    it { is_expected.to have_many(:bays).through(:islets) }
    it { is_expected.to have_many(:frames).through(:bays) }
    it { is_expected.to have_many(:materials).through(:frames) }
  end

  describe "#to_s" do
    it { expect(room.to_s).to eq room.name }
  end

  describe "#name_with_site" do
    pending
  end

  describe "#should_generate_new_friendly_id?" do
    pending
  end
end
