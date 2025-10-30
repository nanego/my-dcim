# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContactRolesController do
  let(:contact_role) { contact_roles(:one) }

  before do
    sign_in users(:admin)
  end

  describe "#index" do
    subject(:response) do
      get contact_roles_path

      @response # rubocop:disable RSpec/InstanceVariable
    end

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(contact_role.name) }

    it { expect { response }.to have_rubanok_processed(ContactRole.all).with(ContactRolesProcessor) }
  end

  describe "#show" do
    before { get contact_role_path(contact_role) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:show) }
    it { expect(response.body).to include(contact_role.name) }

    context "with wrong id" do
      it { expect { get contact_role_path(999_999) }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe "#new" do
    before { get new_contact_role_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "#create" do
    context "with valid parameters" do
      subject(:response) do
        post contact_roles_path, params: params

        # NOTE: used to simplify usage and custom test done in final spec file.
        @response # rubocop:disable RSpec/InstanceVariable
      end

      let(:params) { { contact_role: contact_role.attributes.except("id").merge("name" => "SECU") } }

      it_behaves_like "with create another one"

      it "creates a new ContactRole" do
        expect do
          response
        end.to change(ContactRole, :count).by(1)
      end

      it "redirects to the created contact_role" do
        expect(response).to redirect_to(contact_role_path(assigns(:contact_role)))
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { name: "" } }

      it "does not create a new ContactRole without attributes" do
        expect { post contact_roles_path, params: { contact_role: {} } }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not create a new ContactRole without parameters" do
        expect { post contact_roles_path, params: {} }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not create a new ContactRole with invalid parameters" do
        post contact_roles_path, params: { contact_role: invalid_attributes }

        expect(response).to render_template(:new)
      end
    end
  end

  describe "#edit" do
    before { get edit_contact_role_path(contact_role) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "#update" do
    context "with valid parameters" do
      let(:new_attributes) { contact_role.attributes.except("name").merge("name" => "Livraison") }

      it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        patch contact_role_path(contact_role), params: { contact_role: new_attributes }
        contact_role.reload
        assigns(:contact_role).reload

        expect(response).to be_redirection
        expect(response).to redirect_to(contact_role_path(assigns(:contact_role)))
        expect(contact_role.name).to eq(new_attributes["name"])
      end
    end

    context "with invalid parameters" do
      it "does not update a ContactRole without attributes" do
        expect { patch contact_role_path(contact_role), params: { contact_role: {} } }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not update a ContactRole without parameters" do
        expect { patch contact_role_path(contact_role), params: {} }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not update a ContactRole with invalid parameters", :aggregate_failures do
        patch contact_role_path(contact_role), params: { contact_role: { name: "" } }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "#destroy" do
    it "destroys the requested contact_role" do
      expect do
        delete contact_role_path(contact_role)
      end.to change(ContactRole, :count).by(-1)
    end

    it "redirects to the contact_roles list" do
      delete contact_role_path(contact_role)
      expect(response).to redirect_to(contact_roles_path)
    end
  end
end
