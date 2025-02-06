# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalAppRecordsProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { ExternalAppRecord.all }
  let(:params) { {} }

  describe "when filtering by frame_ids" do
    let(:frame)  { Frame.create!(name: "A1", bay: bays(:one)) }
    let(:server) { Server.create!(name: "server", numero: 1, modele: modeles(:one), frame:) }
    let(:ear) { ExternalAppRecord.create!(server: server) }

    before do
      ear
      ExternalAppRecord.create!(server: servers(:one))
    end

    context "with one frame_id" do
      let(:params) { { frame_ids: frame.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(ear) }
    end

    context "with many frame_ids" do
      let(:server_second) { Server.create!(name: "server3", numero: 3, modele: modeles(:one), frame: frames(:two)) }
      let(:another_ear) { ExternalAppRecord.create!(server: server_second) }

      let(:params) { { frame_ids: [frame.id, frames(:two).id] } }

      before do
        another_ear
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(ear, another_ear) }
    end
  end

  describe "when filtering by modele_ids" do
    let(:ear) { external_app_records(:one) }
    let(:modele) { ear.server.modele }

    before do
      external_app_records(:two).update!(server_id: 3)
    end

    context "with one modele_id" do
      let(:params) { { modele_ids: [modele.id] } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(ear) }
    end

    context "with many modele_ids" do
      let(:another_ear) { external_app_records(:two) }
      let(:another_modele) { modeles(:two) }

      let(:params) { { frame_ids: [modele.id, another_modele.id] } }

      before do
        external_app_records(:three).destroy!
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(ear, another_ear) }
    end
  end

  describe "when filtering by external_serial_status" do
    context "with external_serial_status = found" do
      let(:params) { { external_serial_status: "found" } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to include(external_app_records(:two)) }
    end

    context "with external_serial_status = not_found" do
      let(:params) { { external_serial_status: "not_found" } }

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(external_app_records(:one), external_app_records(:three)) }
    end
  end

  describe "when sorting" do
    pending "TODO"
  end

  describe "When searching on every fields" do
    let(:frame)  { Frame.create!(name: "A1", bay: bays(:one)) }
    let(:server) { Server.create!(name: "server", numero: 1, modele: modeles(:one), frame:) }
    let(:record) { ExternalAppRecord.create!(server:, external_serial: "") }

    let(:params) { { frame_ids: frame.id, external_serial_status: "not_found" } }

    before { record }

    it { expect(result.size).to eq(1) }
    it { is_expected.to contain_exactly(record) }

    described_class::SORTABLE_FIELDS.each do |field|
      context "and sort on #{field}" do # rubocop:disable RSpec/ContextWording
        let(:params) { { frame_ids: frame.id, external_serial_status: "not_found", sort_by: field } }

        it { expect(result.size).to eq(1) }
        it { is_expected.to contain_exactly(record) }
      end
    end
  end
end
