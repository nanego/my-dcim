# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Move do
  # it_behaves_like "changelogable", new_attributes: {  }

  subject(:move) do
    described_class.new(
      step: MovesProjectStep.new, moveable: Server.new, position: 1, frame: Frame.new, prev_frame: Frame.new
    )
  end

  describe "associations" do
    it { is_expected.to belong_to(:step) }
    it { is_expected.to belong_to(:moveable) }
    it { is_expected.to belong_to(:prev_frame) }
    it { is_expected.to belong_to(:frame) }
  end

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:position) }
  end

  describe "#clear_connections" do
    pending
  end

  describe "#execute!" do
    pending
  end
end
