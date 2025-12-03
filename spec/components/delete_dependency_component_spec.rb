# frozen_string_literal: true

require "rails_helper"

RSpec.describe DeleteDependencyComponent, type: :component do
  let(:confirmation_path)  { "/confirmation-path" }
  let(:component)          { described_class.new(record, confirmation_path:) }
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

    it do
      expect(rendered_component).to have_tag("h5.text-danger-emphasis",
                                             ext: "Ressources liées bloquant la suppression")
    end

    it { expect(rendered_component).to have_tag("button", with: { "data-action": "collapse-all#showAll" }) }
    it { expect(rendered_component).to have_tag("div.card-header.text-bg-danger") }
    it { expect(rendered_component).not_to have_tag("div.card-header.text-bg-warning") }
    it { expect(rendered_component).to have_tag("div#collapseCard-documents.collapse_restrict_with_error") }
    it { expect(rendered_component).to have_tag("li.list-group-item", count: 1) }
    it { expect(rendered_component).to have_tag("a.btn-danger.disabled", text: "Supprimer") }
    it { expect(rendered_component).to have_tag("a.btn-default", text: "Annuler") }
    it { expect(rendered_component).not_to have_tag("div.card.text-secondary-emphasis") }
    it { expect(rendered_component).not_to have_tag("span.bi-exclamation-circle.text-danger") }
  end

  context "without restricting dependency" do
    describe "with destroy dependency" do
      let(:record) { Contact.new(first_name: "Dummy", last_name: "name") }

      before do
        allow(record).to receive(:contact_assignments).and_return([ContactAssignment.new])
      end

      it do
        expect(rendered_component).not_to have_tag("h5.text-warning-emphasis", text: ContactAssignment.model_name.human)
      end

      it { expect(rendered_component).to have_tag("div#collapseCard-contact_assignments") }
      it { expect(rendered_component).to have_tag("a.btn-danger", href: confirmation_path) }
      it { expect(rendered_component).not_to have_tag("a.btn-danger.disabled") }
      it { expect(rendered_component).to have_tag("li.list-group-item", text: /#{ContactAssignment.new}/i) }
      it { expect(rendered_component).not_to have_tag("div.card-header.text-bg-danger") }
      it { expect(rendered_component).to have_tag("div.card-header.text-bg-warning") }
      it { expect(rendered_component).not_to have_tag("div.card.text-secondary-emphasis") }
      it { expect(rendered_component).to have_tag("span.bi-exclamation-circle.text-danger") }
    end

    describe "without destroy dependency" do
      let(:record) { Contact.new(first_name: "Dummy", last_name: "name") }

      before do
        allow(record).to receive(:contact_assignments).and_return([])
      end

      it do
        expect(rendered_component).to have_tag("div.card.text-secondary-emphasis") do
          with_tag("div.card-body > span.bi-check2-circle")
        end
      end

      it { expect(rendered_component).to have_tag("a.btn-danger", href: "confirmation-path") }
      it { expect(rendered_component).not_to have_tag("a.btn-danger.disabled") }
      it { expect(rendered_component).not_to have_tag("h5.text-danger-emphasis") }
      it { expect(rendered_component).not_to have_tag("h5.text-warning-emphasis") }
      it { expect(rendered_component).not_to have_tag("li.list-group-item") }
      it { expect(rendered_component).not_to have_tag("div.card-header.text-bg-danger") }
      it { expect(rendered_component).not_to have_tag("div.card-header.text-bg-warning") }
      it { expect(rendered_component).to have_tag("span.bi-exclamation-circle.text-danger") }
    end
  end
end
