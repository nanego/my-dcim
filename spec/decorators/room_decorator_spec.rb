# frozen_string_literal: true

require "rails_helper"

RSpec.describe RoomDecorator, type: :decorator do
  include Rails.application.routes.url_helpers

  let(:room) { rooms(:one) }
  let(:decorated_room) { room.decorated }

  describe ".statuses_options_for_select" do
    it { expect(described_class.statuses_options_for_select.pluck(1)).to match_array(Room.statuses.keys) }
  end

  describe ".access_control_options_for_select" do
    it { expect(described_class.access_control_options_for_select.pluck(1)).to match_array(Room.access_controls.keys) }
  end

  describe ".network_clusters_options_for_select" do
    it do
      expect(described_class.network_clusters_options_for_select)
        .to contain_exactly(["Cloud C1", 1], ["Gbe Cluster", 3], ["elastic", 2])
    end
  end

  describe "#status_to_badge_component" do
    subject(:badge) { decorated_room.status_to_badge_component }

    context "with status = active" do
      it { is_expected.to be_a BadgeComponent }
      it { expect(badge.instance_variable_get(:@color)).to eq :success }
      it { expect(badge.content).to eq "Actif" }
    end

    context "with status = passive" do
      before { rooms(:one).status = :passive }

      it { is_expected.to be_a BadgeComponent }
      it { expect(badge.instance_variable_get(:@color)).to eq :warning }
      it { expect(badge.content).to eq "Passif" }
    end

    context "with status = planned" do
      before { rooms(:one).status = :planned }

      it { is_expected.to be_a BadgeComponent }
      it { expect(badge.instance_variable_get(:@color)).to eq :primary }
      it { expect(badge.content).to eq "Planifié" }
    end

    context "with status = unknown" do
      before { rooms(:one).status = :unknown }

      it { is_expected.to eq({ plain: nil }) }
    end
  end

  describe "#access_control_to_human" do
    subject(:access_control_sentence) { decorated_room.access_control_to_human }

    context "with no access control" do
      it { is_expected.to eq("Pas de contrôle") }
    end

    context "with access control set" do
      before { room.access_control = "badge" }

      it { is_expected.to eq("Badge") }
    end
  end

  describe "#network_clusters_to_sentence" do
    let(:room) { rooms(:five) }

    it { expect(decorated_room.network_clusters_to_sentence).to eq("Cloud C1, elastic") }
  end

  describe "#print_frames_paths" do
    it do
      expect(decorated_room.print_frames_paths)
        .to contain_exactly(print_visualization_frame_path(frames(:one).id),
                            print_visualization_frame_path(frames(:two).id),
                            print_visualization_frame_path(frames(:three).id),
                            print_visualization_frame_path(frames(:four).id))
    end
  end
end
