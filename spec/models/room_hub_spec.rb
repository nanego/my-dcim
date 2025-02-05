# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomHub do
  subject(:room_hub) { described_class.new(name: "Petite salle") }

  describe "associations" do
    it { is_expected.to belong_to(:server_a) }
    it { is_expected.to belong_to(:server_b) }
  end

  describe "validations" do
    pending "TODO"
  end

  describe ".for_room" do
    it { expect(room.to_s).to eq room.name }
  end
end
