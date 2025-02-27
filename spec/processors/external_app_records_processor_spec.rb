# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalAppRecordsProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { ExternalAppRecord.all }
  let(:params) { {} }

  let(:modele_attributes) do
    { manufacturer: manufacturers(:fortinet), architecture: architectures(:rackable), category: categories(:one) }
  end

  describe "when filtering by frame_ids" do
    let(:frame)  { Frame.create!(name: "A1", bay: bays(:one)) }
    let(:server) { Server.create!(name: "server", numero: 1, modele: modeles(:one), frame:) }
    let(:record) { ExternalAppRecord.create!(server:) }

    before do
      record
      ExternalAppRecord.create!(server: servers(:one))
    end

    context "with one frame_id" do
      let(:params) { { frame_ids: frame.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(record) }
    end

    context "with many frame_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:server_second) { Server.create!(name: "server3", numero: 3, modele: modeles(:one), frame: frames(:two)) }
      let(:another_record) { ExternalAppRecord.create!(server: server_second) }

      let(:params) { { frame_ids: [frame.id, frames(:two).id] } }

      before do
        another_record
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(record, another_record) }
    end
  end

  describe "when filtering by modele_ids" do
    let(:modele) { Modele.create!(**modele_attributes) }
    let(:server) { Server.create!(name: "S1", numero: 1, modele:, frame: frames(:one)) }
    let(:record) { ExternalAppRecord.create!(server:, external_serial: "") }

    before { record }

    context "with one modele_id" do
      let(:params) { { modele_ids: modele.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(record) }
    end

    context "with many modele_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:modele_second) { Modele.create!(**modele_attributes) }
      let(:server_second) { Server.create!(name: "S2", numero: 2, modele: modele_second, frame: frames(:one)) }
      let(:record_second) { ExternalAppRecord.create!(server:, external_serial: "") }

      let(:params) { { modele_ids: [modele.id, modele_second.id] } }

      before { record_second }

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(record, record_second) }
    end
  end

  describe "when filtering by server name" do
    let(:frame)  { Frame.create!(name: "A1", bay: bays(:one)) }
    let(:server) { Server.create!(name: "ProcessorServer1", numero: 1, modele: modeles(:one), frame:) }
    let(:record) { ExternalAppRecord.create!(server:) }

    before { record }

    context "with one server name" do
      let(:params) { { server_name: "ProcessorServer1" } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(record) }
    end

    context "with many server names" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:server_second) { Server.create!(name: "ProcessorServer2", numero: 2, modele: modeles(:one), frame:) }
      let(:record_second) { ExternalAppRecord.create!(server: server_second) }

      let(:params) { { server_name: "ProcessorServer" } }

      before { record_second }

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(record, record_second) }
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
    let(:modele) { Modele.create!(**modele_attributes) }
    let(:frame)  { Frame.create!(name: "A1", bay: bays(:one)) }
    let(:server) { Server.create!(name: "S1", numero: 1, modele:, frame:) }
    let(:record) { ExternalAppRecord.create!(server:, external_serial: "") }

    let(:params) { { frame_ids: frame.id, modele_ids: modele.id, server_name: "S1", external_serial_status: "not_found" } }

    before { record }

    it { expect(result.size).to eq(1) }
    it { is_expected.to contain_exactly(record) }

    described_class::SORTABLE_FIELDS.each do |field|
      context "and sort on #{field}" do # rubocop:disable RSpec/ContextWording
        let(:params) { { frame_ids: frame.id, modele_ids: modele.id, server_name: "S1", external_serial_status: "not_found", sort_by: field } }

        it { expect(result.size).to eq(1) }
        it { is_expected.to contain_exactly(record) }
      end
    end
  end
end
