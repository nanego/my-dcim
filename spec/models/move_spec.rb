# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Move, type: :model do
  let(:move) { Move.create(name: "Bleu") }

  describe "associations" do
    it { is_expected.to belong_to(:moveable) }
    it { is_expected.to belong_to(:prev_frame) }
    it { is_expected.to belong_to(:frame) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :moveable }
  end

  describe "#clear_connections" do
    pending
  end

  describe "#execute_movement" do
    pending
  end
end
