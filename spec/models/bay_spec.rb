# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bay, type: :model do
  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  describe "associations" do
    it { is_expected.to belong_to(:bay_type).optional(true) }
    it { is_expected.to belong_to(:islet).optional(true) }
    it { is_expected.to have_one(:room).through(:islet) }
    it { is_expected.to have_many(:frames) }
    it { is_expected.to have_many(:materials).through(:frames) }
  end

  describe "#to_s" do
    pending
  end

  describe "#detailed_name" do
    pending
  end

  describe "#list_frames" do
    pending
  end
end
