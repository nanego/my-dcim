# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Move do
  # it_behaves_like "changelogable", new_attributes: {  }

  subject(:move) { described_class.new(moveable: Server.new, frame: Frame.new, prev_frame: Frame.new) }

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
