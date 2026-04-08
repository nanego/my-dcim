# frozen_string_literal: true

require "rails_helper"

RSpec.describe AirConditioner do
  subject(:air_con) { air_conditioners(:one) }

  describe "associations" do
    it { is_expected.to belong_to(:bay) }
    it { is_expected.to belong_to(:air_conditioner_model).counter_cache(true) }

    it { is_expected.to have_one(:room).through(:bay) }
    it { is_expected.to have_one(:islet).through(:bay) }
  end

  # describe "enum" do
  #   it { is_expected.to define_enum_for(:status).with_values(on: "on", degraded: "degraded", off: "off") }
  #   it { is_expected.to define_enum_for(:position).with_values(left: "left", right: "right") }
  # end

  describe "status attribute" do
    it "is valid with a valid status" do
      ac = described_class.new(name: "X123456", status: "on", air_conditioner_model_id: 1, bay_id: 1, position: "left")
      expect(ac).to be_valid
    end

    it 'is NOT valid if status is not set to "on" or "off"' do
      expect do
        described_class.new(name: "X123456", status: "disabled", air_conditioner_model_id: 1, bay_id: 1, position: "left")
      end.to raise_error(ArgumentError, "'disabled' is not a valid status")
    end
  end

  describe "position attribute" do
    it "is valid with a valid position" do
      ac = described_class.new(name: "X123456", position: "left", status: "on", air_conditioner_model_id: 1, bay_id: 1)
      expect(ac).to be_valid
    end

    it 'is NOT valid if position is set not to "left" or "right"' do
      expect do
        described_class.new(name: "X123456", position: "before", status: "on", air_conditioner_model_id: 1, bay_id: 1)
      end.to raise_error(ArgumentError, "'before' is not a valid position")
    end
  end
end
