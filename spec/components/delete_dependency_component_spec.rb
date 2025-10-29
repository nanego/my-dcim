# frozen_string_literal: true

require "rails_helper"

RSpec.describe DeleteDependencyComponent, type: :component do
  let(:confirmation_path) { "/confirmation-path" }
  let(:component) { described_class.new(record, confirmation_path:) }
  let(:rendered_component) { render_inline(component).to_html }

  before { allow(component).to receive(:url_for).and_return("/fake/url") }

  context "with restricting dependency" do
    let(:record) do
      server = Server.new(name: "Dummy name")
      document = Document.new
      allow(document).to receive_messages(
        document: instance_double(DocumentUploader::UploadedFile, metadata: { filename: "this is a filename" }),
        document_url: "/fake/url",
      )

      allow(server).to receive_messages(
        external_app_record: [],
        documents: [document],
        moves: [],
      )

      server
    end

    it { expect(rendered_component).to have_tag("h4", title: Document.model_name.human) }
    it { expect(rendered_component).to have_tag("a[target=_blank]", href: "/fake/url", title: "this is a filename") }
    it { expect(rendered_component).not_to have_tag("a.btn-danger") }
    it { expect(rendered_component).not_to have_tag("a.btn-default") }
  end

  context "without restricting dependency" do
    describe "with destroy dependency" do
      let(:record) do
        contact = Contact.new(first_name: "Dummy", last_name: "name")
        allow(contact).to receive(:contact_assignments).and_return([ContactAssignment.new])
        contact
      end

      it { expect(rendered_component).to have_tag("a.btn-danger", href: "confirmation-path") }
      it { expect(rendered_component).to have_tag("a.btn-default") }
      it { expect(rendered_component).to have_tag("h4", title: ContactAssignment.model_name.human) }
      it { expect(rendered_component).to have_tag("a[target=_blank]", href: "/fake/url", title: ContactAssignment.new.to_s) }
    end

    describe "without destroy dependency" do
      let(:record) do
        contact = Contact.new(first_name: "Dummy", last_name: "name")
        allow(contact).to receive(:contact_assignments).and_return([])
        contact
      end

      it { expect(rendered_component).to have_tag("a.btn-danger", href: "confirmation-path") }
      it { expect(rendered_component).to have_tag("a.btn-default") }
      it { expect(rendered_component).not_to have_tag("h4", title: ContactAssignment.model_name.human) }
      it { expect(rendered_component).not_to have_tag("a[target=_blank]", href: "/fake/url", title: ContactAssignment.new.to_s) }
    end
  end
end
