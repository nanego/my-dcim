# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnitType do
  describe "associations" do
    it { is_expected.to belong_to(:manufacturer) }
  end
end
