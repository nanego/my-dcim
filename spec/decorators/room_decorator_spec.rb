# frozen_string_literal: true

require "rails_helper"

RSpec.describe RoomDecorator, type: :decorator do
  describe ".statuses_for_options" do
    it { expect(described_class.statuses_for_options.pluck(1)).to match_array(Room.statuses.keys) }
  end

  describe "#badge_color_for_status" do
    subject(:badge_color) { rooms(:one).decorated.badge_color_for_status }

    context "with status = active" do
      it { is_expected.to eq "text-bg-success" }
    end

    context "with status = passive" do
      before { rooms(:one).status = :passive }

      it { is_expected.to eq "text-bg-warning" }
    end

    context "with status = planned" do
      before { rooms(:one).status = :planned }

      it { is_expected.to eq "text-bg-primary" }
    end

    context "with status = unknown" do
      before { rooms(:one).status = :unknown }

      it { is_expected.to be_nil }
    end
  end
end
