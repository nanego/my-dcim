# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Move, type: :model do
  subject(:move) { Move.new(moveable: Server.new, frame: Frame.new, prev_frame: Frame.new) }

  describe "associations" do
    it { is_expected.to belong_to(:moveable) }
    it { is_expected.to belong_to(:prev_frame) }
    it { is_expected.to belong_to(:frame) }
  end

  describe "validations" do
    it { is_expected.to be_valid }
  end

  describe "#clear_connections" do
    pending
  end

  describe "#execute_movement" do
    pending
  end
end
