# frozen_string_literal: true

require "rails_helper"

RSpec.describe DeleteDependencyComponent, type: :component do
  let(:confirmation_path) { "/confirmation-path" }
  let(:component) { described_class.new(record, confirmation_path:) }
  let(:rendered_component) { render_inline(component).to_html }

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

    it { expect(rendered_component).to have_tag("h4", title: Document.model_name.human) }
    it { expect(rendered_component).to have_tag("li.list-group-item", title: "this is a filename") }
    it { expect(rendered_component).not_to have_tag("a.btn-danger") }
    it { expect(rendered_component).not_to have_tag("a.btn-default") }
  end

  context "without restricting dependency" do
    describe "with destroy dependency" do
      let(:record) { Contact.new(first_name: "Dummy", last_name: "name") }

      before do
        allow(record).to receive(:contact_assignments).and_return([ContactAssignment.new])
      end

      it { expect(rendered_component).to have_tag("a.btn-danger", href: confirmation_path) }
      it { expect(rendered_component).to have_tag("a.btn-default") }
      it { expect(rendered_component).to have_tag("h4", title: ContactAssignment.model_name.human) }
      it { expect(rendered_component).to have_tag("li.list-group-item", title: ContactAssignment.new.to_s) }
    end

    describe "without destroy dependency" do
      let(:record) { Contact.new(first_name: "Dummy", last_name: "name") }

      before do
        allow(record).to receive(:contact_assignments).and_return([])
      end

      it { expect(rendered_component).to have_tag("a.btn-danger", href: "confirmation-path") }
      it { expect(rendered_component).to have_tag("a.btn-default") }
      it { expect(rendered_component).not_to have_tag("h4", title: ContactAssignment.model_name.human) }
      it { expect(rendered_component).not_to have_tag("li.list-group-item") }
    end
  end
end
