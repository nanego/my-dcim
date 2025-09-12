# frozen_string_literal: true

require "rails_helper"

RSpec.describe PermissionScopesController do
  let(:permission_scope) { permission_scopes(:one) }

  before do
    sign_in users(:admin)
  end

  describe "GET #index" do
    before { get permission_scopes_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(permission_scope.name) }
  end

  describe "GET #show" do
    before { get permission_scope_path(permission_scope) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:show) }
    it { expect(response.body).to include(permission_scope.name) }

    context "with an id not set" do
      it { expect { get permission_scope_path("unknown-id") }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe "GET #new" do
    before { get new_permission_scope_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "POST #create" do
    context "with valid parameters" do
      subject(:response) do
        post permission_scopes_path, params: params

        # NOTE: used to simplify usage and custom test done in final spec file.
        @response # rubocop:disable RSpec/InstanceVariable
      end

      let(:params) do
        { permission_scope: permission_scope.attributes.except(%w[id]) }
      end

      it { expect { response }.to change(PermissionScope, :count).by(1) }
      it { expect(response).to redirect_to(permission_scope_path(assigns(:permission_scope))) }
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { name: "" } }

      it "does not create a new PermissionScope without attributes" do
        expect { post permission_scopes_path, params: { permission_scope: {} } }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not create a new PermissionScope without parameters" do
        expect { post permission_scopes_path, params: {} }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not create a new PermissionScope with invalid parameters" do
        post permission_scopes_path, params: { permission_scope: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    before { get edit_permission_scope_path(permission_scope) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let(:new_attributes) { permission_scope.attributes.except("name").merge(name: "New name") }

      it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        patch permission_scope_path(permission_scope), params: { permission_scope: new_attributes }
        permission_scope.reload
        # assigns(:permission_scope).reload

        expect(response).to be_redirection
        expect(response).to redirect_to(permission_scope_path(assigns(:permission_scope)))
        expect(permission_scope.name).to eq(new_attributes[:name])
      end
    end

    context "with invalid parameters" do
      it "does not update a Server without attributes" do
        expect { patch permission_scope_path(permission_scope), params: { permission_scope: {} } }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not update a Server without parameters" do
        expect { patch permission_scope_path(permission_scope), params: {} }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not update a Server with invalid parameters", :aggregate_failures do
        patch permission_scope_path(permission_scope), params: { permission_scope: { name: "" } }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    context "with a permission_scope without association" do
      it "destroys the requested permission_scope" do
        expect do
          delete permission_scope_path(permission_scope)
        end.to change(PermissionScope, :count).by(-1)
      end

      it "redirects to the permission_scopes list" do
        delete permission_scope_path(permission_scope)
        expect(response).to redirect_to(permission_scopes_path)
      end
    end
  end
end
