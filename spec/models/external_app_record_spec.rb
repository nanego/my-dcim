# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalAppRecord do
  describe "associations" do
    it { is_expected.to belong_to(:server) }
    it { is_expected.to have_one(:frame).through(:server) }
  end

  describe ".sync_server_with_glpi" do
    pending "TODO"
  end
end
