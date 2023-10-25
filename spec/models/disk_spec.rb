# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Disk, type: :model do
  it_behaves_like "changelogable", new_attributes: { quantity: 2 }

  describe "associations" do
    it { is_expected.to belong_to(:server).optional(true) }
    it { is_expected.to belong_to(:disk_type).optional(true) }
  end

  describe "#to_s" do
    pending
  end
end
