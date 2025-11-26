# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecordDependencies do
  subject(:record_dependencies) { described_class.new(record) }

  let(:record)   { Server.new(name: "Dummy name") }
  let(:document) { Document.new }
  let(:move)     { Move.new }

  describe "#destroyable" do
    context "when no records associated" do
      it { expect(record_dependencies.destroyable).to be_empty }
    end

    context "when destroyable records associated" do
      before do
        allow(record).to receive_messages(external_app_record: [], documents: [], moves: [move])
      end

      it { expect(record_dependencies.destroyable).not_to be_empty }
      it { expect(record_dependencies.destroyable).to all(be_a(RecordDependencies::Dependency)) }
      it { expect(record_dependencies.destroyable).to all(have_attributes(type: :destroy)) }

      it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        expect(record_dependencies.destroyable.size).to eq(1)

        record_dependencies.destroyable.each do |dependency|
          expect(dependency.title).to eq("Déplacement prévu")
          expect(dependency.records).to all(be_a(Move))
          expect(dependency.type).to eq(:destroy)
          expect(dependency.empty?).to be(false)
        end
      end
    end
  end

  describe "#restricted_with_error" do
    context "when no records associated" do
      it { expect(record_dependencies.restricted_with_error).to be_empty }
    end

    context "when destroyable records associated" do
      before do
        allow(document).to receive_messages(
          document: instance_double(DocumentUploader::UploadedFile, metadata: { filename: "this is a filename" }),
          document_url: "/fake/url",
        )

        allow(record).to receive_messages(external_app_record: [], documents: [document], moves: [])
      end

      it { expect(record_dependencies.restricted_with_error).not_to be_empty }
      it { expect(record_dependencies.restricted_with_error).to all(be_a(RecordDependencies::Dependency)) }
      it { expect(record_dependencies.restricted_with_error).to all(have_attributes(type: :restrict_with_error)) }

      it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        expect(record_dependencies.restricted_with_error.size).to eq(1)

        record_dependencies.restricted_with_error.each do |dependency|
          expect(dependency.title).to eq("Document")
          expect(dependency.records).to all(be_a(Document))
          expect(dependency.type).to eq(:restrict_with_error)
          expect(dependency.empty?).to be(false)
        end
      end
    end
  end
end
