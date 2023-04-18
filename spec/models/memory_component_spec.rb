# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MemoryComponent, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:server) }
    it { is_expected.to belong_to(:memory_type) }
  end

  describe "#to_s" do
    pending
  end
end
