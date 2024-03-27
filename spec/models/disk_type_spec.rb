# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiskType do
  subject(:disk_type) { described_class.new(quantity: 120, unit: "Gb", technology: "SSD") }

  it_behaves_like "changelogable", new_attributes: { quantity: 120 }

  describe "associations" do
    it { is_expected.to have_many(:disks) }
  end

  describe "#to_s" do
    it { expect(disk_type.to_s).to eq "SSD 120 Gb" }
  end
end
