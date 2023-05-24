# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BayType, type: :model do
  let(:bay_type) { BayType.create(name: "single") }

  describe "associations" do
    it { is_expected.to have_many(:bays) }
  end

  describe "#to_s" do
    it { expect(bay_type.to_s).to eq bay_type.name }
  end
end
