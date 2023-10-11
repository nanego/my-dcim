# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Port, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:card).optional }
    it { is_expected.to have_one(:server).through(:card) }
    it { is_expected.to have_one(:connection) }
    it { is_expected.to have_one(:cable).through(:connection) }
  end

  describe "#network_conf" do
    pending
  end

  describe "#connect_to_port" do
    pending
  end
end
