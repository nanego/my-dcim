# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiskType, type: :model do
  let(:disk_type) { DiskType.create(quantity: 120, unit: "Gb", technology: "SSD") }

  describe "associations" do
    it { is_expected.to have_many(:disks) }
  end

  describe "#to_s" do
    it { expect(disk_type.to_s).to eq "SSD 120 Gb" }
  end
end
