# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Islet, type: :model do
  let(:islet) { Islet.create(name: "Bleu") }

  describe "associations" do
    it { is_expected.to belong_to(:room) }
    it { is_expected.to have_one(:site).through(:room) }
    it { is_expected.to have_many(:bays) }
    it { is_expected.to have_many(:frames).through(:bays) }
    it { is_expected.to have_many(:servers).through(:frames) }
    it { is_expected.to have_many(:materials).through(:frames) }
  end

  describe "#to_s" do
    pending
  end

  describe "#name_with_room" do
    pending
  end
end
