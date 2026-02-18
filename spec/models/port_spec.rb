# frozen_string_literal: true

require "rails_helper"

RSpec.describe Port do
  # it_behaves_like "changelogable", new_attributes: {  }

  describe "associations" do
    it { is_expected.to belong_to(:card) }

    it { is_expected.to have_one(:server).through(:card) }
    it { is_expected.to have_one(:connection) }
    it { is_expected.to have_one(:cable).through(:connection) }

    it { is_expected.to have_many(:connections).dependent(:destroy) }
    it { is_expected.to have_many(:moved_connection_froms).dependent(:destroy) }
    it { is_expected.to have_many(:moved_connection_tos).dependent(:nullify) }
  end

  describe "#network_conf" do
    pending
  end

  describe "#connect_to_port" do
    pending
  end
end
