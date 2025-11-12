# frozen_string_literal: true

require "rails_helper"

RSpec.describe PermissionScopeUsersController do
  let(:permission_scope_user) { permission_scope_users(:one) }
  let(:permission_scope) { permission_scope_user.permission_scope }

  before do
    sign_in users(:admin)
  end

  describe "POST #create" do
    context "with valid parameters" do
      subject(:response) do
        post permission_scope_permission_scope_users_path(permission_scope), params: params

        # NOTE: used to simplify usage and custom test done in final spec file.
        @response # rubocop:disable RSpec/InstanceVariable
      end

      let(:params) do
        { permission_scope_user: { user_id: users(:without_permission_scope).id } }
      end

      it { expect { response }.to change(PermissionScopeUser, :count).by(1) }
      it { expect(response).to redirect_to(permission_scope_path(permission_scope)) }
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { user_id: "" } }

      it "does not create a new PermissionScope without attributes" do
        expect { post permission_scope_permission_scope_users_path(permission_scope), params: { permission_scope_user: {} } }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not create a new PermissionScope without parameters" do
        expect { post permission_scope_permission_scope_users_path(permission_scope), params: {} }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not create a new PermissionScope with invalid parameters" do
        post permission_scope_permission_scope_users_path(permission_scope), params: { permission_scope_user: invalid_attributes }

        expect(response).to redirect_to(permission_scope_path(permission_scope))
      end
    end

    context "with turbo_stream request" do
      subject(:response) do
        post permission_scope_permission_scope_users_path(permission_scope), params: params, as: :turbo_stream

        # NOTE: used to simplify usage and custom test done in final spec file.
        @response # rubocop:disable RSpec/InstanceVariable
      end

      let(:params) do
        { permission_scope_user: { user_id: users(:without_permission_scope).id } }
      end

      it { expect { response }.to change(PermissionScopeUser, :count).by(1) }
      it { expect(response).to render_template(:create) }
    end
  end

  describe "DELETE #destroy" do
    context "with a permission_scope without association" do
      it "destroys the requested permission_scope" do
        expect do
          delete permission_scope_permission_scope_user_path(permission_scope, permission_scope_user)
        end.to change(PermissionScopeUser, :count).by(-1)
      end

      it "redirects to the permission_scopes list" do
        delete permission_scope_permission_scope_user_path(permission_scope, permission_scope_user)
        expect(response).to redirect_to(permission_scope_path(permission_scope))
      end
    end
  end
end
