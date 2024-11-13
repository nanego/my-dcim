# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ContactAssignmentsController" do
  let(:contact_assignment) do
    ContactAssignment.create!(site: sites(:one), contact: contacts(:one), contact_role: contact_roles(:one))
  end

  before do
    sign_in users(:one)
  end

  describe "#index" do
    before { get contact_assignments_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }

    it { expect(response.body).to include(contact_assignment.site_id.to_s) }
  end

  describe "#show" do
    before { get contact_assignment_path(contact_assignment) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:show) }
    it { expect(response.body).to include(contact_assignment.site_id.to_s) }

    context "with wrong id" do
      it { expect { get contact_assignment_path(999_999) }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe "#new" do
    before { get new_contact_assignment_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "#create" do
    context "with valid parameters" do
      before { contact_assignment }

      let(:valid_attributes) do
        contact_assignment.attributes.except("id")
          .merge("site_id" => sites(:two).id, "contact_id" => contacts(:two).id, "contact_role_id" => contact_roles(:two).id)
      end

      it "creates a new ContactAssignment" do
        expect do
          post contact_assignments_path, params: { contact_assignment: valid_attributes }
        end.to change(ContactAssignment, :count).by(1)
      end

      it "redirects to the created contact_assignment" do
        post contact_assignments_path, params: { contact_assignment: valid_attributes }

        expect(response).to redirect_to(contact_assignment_path(assigns(:contact_assignment)))
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { site_id: "" } }

      it "does not create a new ContactAssignment without attributes" do
        expect { post contact_assignments_path, params: { contact_assignment: {} } }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not create a new ContactAssignment without parameters" do
        expect { post contact_assignments_path, params: {} }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not create a new ContactAssignment with invalid parameters" do
        post contact_assignments_path, params: { contact_assignment: invalid_attributes }

        expect(response).to render_template(:new)
      end
    end
  end

  describe "#edit" do
    before { get edit_contact_assignment_path(contact_assignment) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "#update" do
    context "with valid parameters" do
      let(:new_attributes) { contact_assignment.attributes.except("site_id").merge("site_id" => sites(:one).id) }

      it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        patch contact_assignment_path(contact_assignment), params: { contact_assignment: new_attributes }
        contact_assignment.reload
        assigns(:contact_assignment).reload

        expect(response).to be_redirection
        expect(response).to redirect_to(contact_assignment_path(assigns(:contact_assignment)))
        expect(contact_assignment.site_id).to eq(new_attributes["site_id"])
      end
    end

    context "with invalid parameters" do
      it "does not update a ContactAssignment without attributes" do
        expect { patch contact_assignment_path(contact_assignment), params: { contact_assignment: {} } }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not update a ContactAssignment without parameters" do
        expect { patch contact_assignment_path(contact_assignment), params: {} }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not update a ContactAssignment with invalid parameters", :aggregate_failures do
        patch contact_assignment_path(contact_assignment), params: { contact_assignment: { site_id: "" } }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "#destroy" do
    before { contact_assignment }

    it "destroys the requested contact_assignment" do
      expect do
        delete contact_assignment_path(contact_assignment)
      end.to change(ContactAssignment, :count).by(-1)
    end

    it "redirects to the contact_assignments list" do
      delete contact_assignment_path(contact_assignment)
      expect(response).to redirect_to(contact_assignments_path)
    end
  end
end
