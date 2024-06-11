# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AirConditioner do
  describe "status attribute" do
    it 'is valid with a valid status' do
      ac = described_class.new(name: 'X123456', status: 'on', air_conditioner_model_id: 1, bay_id: 1, position: 'left')
      expect(ac).to be_valid
    end

    it 'is NOT valid if status is not set to "on" or "off"' do
      expect do
        described_class.new(name: 'X123456', status: 'disabled', air_conditioner_model_id: 1, bay_id: 1, position: 'left')
      end.to raise_error(ArgumentError, "'disabled' is not a valid status")
    end
  end

  describe "position attribute" do
    it 'is valid with a valid position' do
      ac = described_class.new(name: 'X123456', position: 'left', status: 'on', air_conditioner_model_id: 1, bay_id: 1)
      expect(ac).to be_valid
    end

    it 'is NOT valid if position is set not to "left" or "right"' do
      expect do
        described_class.new(name: 'X123456', position: 'before', status: 'on', air_conditioner_model_id: 1, bay_id: 1)
      end.to raise_error(ArgumentError, "'before' is not a valid position")
    end
  end
end
