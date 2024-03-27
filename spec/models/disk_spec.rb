# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Disk do
  # it_behaves_like "changelogable", new_attributes: { quantity: 2 }

  describe "associations" do
    it { is_expected.to belong_to(:server) }
    it { is_expected.to belong_to(:disk_type) }
  end

  describe "#to_s" do
    pending
  end
end
