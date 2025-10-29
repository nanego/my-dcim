# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecordDependencies do
  subject(:dep) do
    described_class.new(record)
  end

  context "with restricting dependency" do
    let(:record) { Server.new(name: "Dummy name") }
    let(:document) { Document.new }

    before do
      allow(document).to receive_messages(
        document: instance_double(DocumentUploader::UploadedFile, metadata: { filename: "this is a filename" }),
        document_url: "/fake/url",
      )

      allow(record).to receive_messages(
        external_app_record: [],
        documents: [document],
        moves: [],
      )
    end

    it { expect(dep.restricted_with_error[0].records).to eq([document]) }
    it { expect(dep.restricted_with_error[0].name).to be(:documents) }
    it { expect(dep.restricted_with_error[0].title).to be(Document.model_name.human) }
    it { expect(dep.destroyable.length).to be(0) }
  end

  context "with destroyable dependency" do
    let(:record) { Server.new(name: "Dummy name") }
    let(:move) { Move.new }

    before do
      allow(record).to receive_messages(
        external_app_record: [],
        documents: [],
        moves: [move],
      )
    end

    it { expect(dep.destroyable[0].records).to eq([move]) }
    it { expect(dep.destroyable[0].name).to be(:moves) }
    it { expect(dep.destroyable[0].title).to be(Move.model_name.human) }
    it { expect(dep.restricted_with_error.length).to be(0) }
  end
end
