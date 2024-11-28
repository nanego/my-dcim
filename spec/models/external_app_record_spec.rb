# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalAppRecord do
  describe "associations" do
    it { is_expected.to belong_to(:server) }
    it { is_expected.to have_one(:frame).through(:server) }
  end
end
