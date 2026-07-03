# frozen_string_literal: true

require "rails_helper"

RSpec.describe Connection do
  # it_behaves_like "changelogable", new_attributes: {  }

  describe "associations" do
    it { is_expected.to belong_to(:cable) }
    it { is_expected.to belong_to(:port) }

    it { is_expected.to have_one(:card).through(:port).source(:attachable) }
    it { is_expected.to have_one(:server).through(:card) }
    it { is_expected.to have_one(:card_type).through(:card) }
    it { is_expected.to have_one(:port_type).through(:card_type) }

    it { is_expected.to have_one(:socket).through(:port).source(:attachable) }
    it { is_expected.to have_one(:power_distribution_unit).through(:socket) }
  end

  describe "#paired_connection" do
    pending
  end
end
