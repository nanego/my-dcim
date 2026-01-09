# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersController do
  let(:user)       { users(:one) }
  let(:admin_user) { users(:admin) }

  describe "GET #index" do
    subject(:response) do
      get users_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    context "with admin user" do
      include_context "with authenticated admin"

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:index) }

      it { expect { response }.to have_rubanok_processed(User.all).with(UsersProcessor) }
    end

    context "with regular user" do
      include_context "with authenticated user"

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(root_path) }
    end
  end

  describe "GET #show" do
    subject(:response) do
      get user_path(record)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:record) do
      User.create!(email: "user-target@example.com", password: "passwordpassword", permission_scopes: [permission_scopes(:all)])
    end

    context "with admin user" do
      include_context "with authenticated admin"

      context "with not found user" do
        let(:record) { User.new(id: 999_999_999) }

        it { expect { response }.to raise_error(ActiveRecord::RecordNotFound) }
      end

      context "with existing user" do
        it { expect(response).to have_http_status(:success) }
        it { expect(response).to render_template(:show) }
      end
    end

    context "with regular user" do
      include_context "with authenticated user"

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(root_path) }
    end

    context "with user is current_user" do
      include_context "with authenticated user" do
        let(:user) { record }
      end

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:show) }
    end
  end

  describe "GET #new" do
    subject(:response) do
      get(new_user_path)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    context "with admin user" do
      include_context "with authenticated admin"

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:new) }
    end

    context "with regular user" do
      include_context "with authenticated user"

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(root_path) }
    end
  end

  describe "POST #add_user" do
    subject(:response) do
      post add_user_users_path, params: params

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:valid_attributes) { { email: "user@example.com", password: "passwordpassword" } }
    let(:invalid_attributes) { { email: "" } }
    let(:params) { { user: valid_attributes } }

    include_context "with authenticated admin"

    context "with valid parameters" do
      it { expect { response }.to change(User, :count).by(1) }
      it { expect(response).to redirect_to(users_path) }
    end

    context "without attributes" do
      let(:params) { { user: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "with invalid parameters" do
      let(:params) { { user: invalid_attributes } }

      it { expect(response).to render_template(:new) }
    end
  end

  describe "GET #edit" do
    subject(:response) do
      get(edit_user_path(user))

      @response # rubocop:disable RSpec/InstanceVariable
    end

    context "when user is admin" do
      include_context "with authenticated admin"

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:edit) }
    end

    context "when current user is not admin" do
      include_context "with authenticated user" do
        let(:user) { users(:reader) }
      end

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(root_path) }
    end
  end

  describe "PATCH #update" do
    subject(:response) do
      patch(user_path(record), params: params)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:record) { User.create!(email: "user-target@example.com", password: "passwordpassword") }
    let(:valid_attributes) { { email: "user-new-target@example.com" } }
    let(:invalid_attributes) { { email: "" } }
    let(:params) { { user: valid_attributes } }

    include_context "with authenticated admin"

    context "when user is not admin" do
      include_context "with authenticated user"

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(root_path) }
    end

    context "with valid parameters" do
      it do
        expect do
          response
          record.reload
        end.to change(record, :email).from("user-target@example.com").to("user-new-target@example.com")
      end

      it { expect(response).to redirect_to(users_path) }
    end

    context "without attributes" do
      let(:params) { { user: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "with invalid parameters" do
      let(:params) { { user: invalid_attributes } }

      it { expect(response).to have_http_status(:unprocessable_content) }
      it { expect(response).to render_template(:edit) }
    end
  end

  describe "DELETE #destroy" do
    subject(:response) do
      delete user_path(target_user, confirm: true, params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:target_user) { users(:two) }
    let(:params) { {} }

    include_context "with authenticated admin"

    context "without confirm" do
      subject(:response) do
        delete user_path(target_user, params:)
        @response # rubocop:disable RSpec/InstanceVariable
      end

      it do
        expect do
          response
        end.not_to change(User, :count)
      end

      it { expect(response).to have_http_status(:success) }
      it { expect(User.exists?(target_user.id)).to be true }
    end

    context "with admin user" do
      it do
        expect do
          response
        end.to change(User, :count).by(-1)
      end

      it { expect(response).to have_http_status(:redirect) }
    end

    context "with sort and filters params" do
      let(:params) { { sort: "asc", sort_by: :created_at } }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(users_path({ sort: "asc", sort_by: :created_at })) }
    end

    context "with regular user" do
      include_context "with authenticated user"

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(root_path) }
    end

    context "when user asks for itself" do
      let(:target_user) { admin_user }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(root_path) }
    end
  end

  describe "PATCH #suspend" do
    subject(:response) do
      patch suspend_user_path(target_user, params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:target_user) { users(:one) }
    let(:params) { {} }

    context "with admin user" do
      include_context "with authenticated admin"

      it do
        expect do
          response
          target_user.reload
        end.to change(target_user, :suspended_at).from(nil)
      end

      it { expect(response).to have_http_status(:redirect) }
    end

    context "with sort and filters params" do
      let(:params) { { sort: "asc", sort_by: :created_at } }

      include_context "with authenticated admin"

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(users_path({ sort: "asc", sort_by: :created_at })) }
    end

    context "with regular user" do
      include_context "with authenticated user"

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(root_path) }
    end

    context "with target user same as current user" do
      let(:target_user) { admin_user }

      include_context "with authenticated user" do
        let(:user) { admin_user }
      end

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(root_path) }
    end
  end

  describe "PATCH #unsuspend" do
    subject(:response) do
      patch unsuspend_user_path(suspended_user, params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:suspended_user) do
      User.create!(email: "user2@example.com", password: "passwordpassword", suspended_at: Time.zone.now)
    end
    let(:params) { {} }

    context "with admin user" do
      include_context "with authenticated admin"

      it do
        expect do
          response
          suspended_user.reload
        end.to change(suspended_user, :suspended_at).to(nil)
      end

      it { expect(response).to have_http_status(:redirect) }
    end

    context "with sort and filters params" do
      let(:params) { { sort: "asc", sort_by: :created_at } }

      include_context "with authenticated admin"

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(users_path({ sort: "asc", sort_by: :created_at })) }
    end

    context "with regular user" do
      include_context "with authenticated user"

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(root_path) }
    end
  end
end
