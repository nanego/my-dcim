# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MemoryComponent, type: :model do
  # it_behaves_like "changelogable", new_attributes: { quantity: 123 }

  describe "associations" do
    it { is_expected.to belong_to(:server) }
    it { is_expected.to belong_to(:memory_type) }
  end

  describe "#to_s" do
    pending
  end
end
