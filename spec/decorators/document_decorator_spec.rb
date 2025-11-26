# frozen_string_literal: true

require "rails_helper"

RSpec.describe DocumentDecorator, type: :decorator do
  let(:document) { Document.new }
  let(:decorated_document) { document.decorated }

  before do
    allow(document).to receive_messages(
      document: instance_double(DocumentUploader::UploadedFile, metadata: { "filename" => "file.pdf" }),
      document_url: "/fake/url",
    )
  end

  describe "#display_name" do
    it { expect(decorated_document.display_name).to eq("file.pdf") }
  end
end
