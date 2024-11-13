# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ContactsController" do
  let(:contact) { contacts(:one) }

  before do
    sign_in users(:one)
  end

  describe "#index" do
    before { get contacts_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }

    it { expect(response.body).to include(contact.first_name) }
  end

  describe "#show" do
    before { get contact_path(contact) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:show) }
    it { expect(response.body).to include(contact.first_name) }

    context "with wrong id" do
      it { expect { get contact_path(999_999) }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe "#new" do
    before { get new_contact_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "#create" do
    context "with valid parameters" do
      let(:valid_attributes) do
        contact.attributes.except("id").merge("first_name" => "John", "last_name" => "Doe")
      end

      it "creates a new Contact" do
        expect do
          post contacts_path, params: { contact: valid_attributes }
        end.to change(Contact, :count).by(1)
      end

      it "redirects to the created contact" do
        post contacts_path, params: { contact: valid_attributes }

        expect(response).to redirect_to(contact_path(assigns(:contact)))
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { first_name: "" } }

      it "does not create a new Contact without attributes" do
        expect { post contacts_path, params: { contact: {} } }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not create a new Contact without parameters" do
        expect { post contacts_path, params: {} }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not create a new Contact with invalid parameters" do
        post contacts_path, params: { contact: invalid_attributes }

        expect(response).to render_template(:new)
      end
    end
  end

  describe "#edit" do
    before { get edit_contact_path(contact) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "#update" do
    context "with valid parameters" do
      let(:new_attributes) { contact.attributes.except("first_name").merge("first_name" => "New name") }

      it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        patch contact_path(contact), params: { contact: new_attributes }
        contact.reload
        assigns(:contact).reload

        expect(response).to be_redirection
        expect(response).to redirect_to(contact_path(assigns(:contact)))
        expect(contact.first_name).to eq(new_attributes["first_name"])
      end
    end

    context "with invalid parameters" do
      it "does not update a Contact without attributes" do
        expect { patch contact_path(contact), params: { contact: {} } }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not update a Contact without parameters" do
        expect { patch contact_path(contact), params: {} }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not update a Contact with invalid parameters", :aggregate_failures do
        patch contact_path(contact), params: { contact: { first_name: "" } }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "#destroy" do
    it "destroys the requested contact" do
      expect do
        delete contact_path(contact)
      end.to change(Contact, :count).by(-1)
    end

    it "redirects to the contacts list" do
      delete contact_path(contact)
      expect(response).to redirect_to(contacts_path)
    end
  end
end
