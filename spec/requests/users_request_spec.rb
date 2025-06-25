# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users" do
  let(:user)       { User.create!(email: "user@example.com", password: "passwordpassword", role: "user") }
  let(:admin_user) { User.create!(email: "admin@example.com", password: "passwordpassword", role: "admin") }

  describe "GET #index" do
    context "with admin user" do
      include_context "with authenticated user" do
        let(:user) { admin_user }
      end

      before { get users_path }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:index) }
    end

    context "with regular user" do
      include_context "with authenticated user"

      before { get users_path }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(root_path) }
    end
  end

  describe "GET /edit_user" do
    subject(:response) do
      get(edit_user_path(user))

      @response # rubocop:disable RSpec/InstanceVariable
    end

    context "when user is admin" do
      include_context "with authenticated user" do
        let(:user) { users(:admin) }
      end

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:edit) }
    end

    context "when current user is not admin" do
      include_context "with authenticated user" do
        let(:user) { users(:one) }
      end

      it { expect { response }.to raise_error(ActionPolicy::Unauthorized) }
    end
  end

  describe "GET #show" do
    subject(:response) do
      get user_path(record)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:record) { User.create!(email: "user-target@example.com", password: "passwordpassword") }

    context "with admin user" do
      include_context "with authenticated user" do
        let(:user) { admin_user }
      end

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
    context "with admin user" do
      include_context "with authenticated user" do
        let(:user) { admin_user }
      end

      before { get new_user_path }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:new) }
    end

    context "with regular user" do
      include_context "with authenticated user"

      before { get new_user_path }

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

    include_context "with authenticated user" do
      let(:user) { admin_user }
    end

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

  describe "PATCH #update" do
    subject(:response) do
      patch user_path(record), params: params

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:record) { User.create!(email: "user-target@example.com", password: "passwordpassword") }
    let(:valid_attributes) { { role: "admin" } }
    let(:invalid_attributes) { { role: "" } }
    let(:params) { { user: valid_attributes } }

    include_context "with authenticated user" do
      let(:user) { admin_user }
    end

    context "with valid parameters" do
      it do
        expect do
          response
          record.reload
        end.to change(record, :role).to("admin")
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

      it { expect(response).to redirect_to(users_path) }
    end
  end

  describe "DELETE #destroy" do
    subject(:response) do
      delete user_path(user)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    context "with admin user" do
      include_context "with authenticated user" do
        let(:user) { admin_user }
      end

      it do
        expect do
          response
        end.to change(User, :count).by(-1)
      end

      it { expect(response).to have_http_status(:redirect) }
    end

    context "with regular user" do
      include_context "with authenticated user"

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(root_path) }
    end
  end

  describe "PATCH #suspend" do
    subject(:response) do
      patch suspend_user_path(user)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    context "with admin user" do
      include_context "with authenticated user" do
        let(:user) { admin_user }
      end

      it do
        expect do
          response
          user.reload
        end.to change(user, :suspended_at).from(nil)
      end

      it { expect(response).to have_http_status(:redirect) }
    end

    context "with regular user" do
      include_context "with authenticated user"

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(root_path) }
    end
  end

  describe "PATCH #unsuspend" do
    subject(:response) do
      patch unsuspend_user_path(suspended_user)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:suspended_user) do
      User.create!(email: "user2@example.com", password: "passwordpassword", suspended_at: Time.zone.now)
    end

    context "with admin user" do
      include_context "with authenticated user" do
        let(:user) { admin_user }
      end

      it do
        expect do
          response
          suspended_user.reload
        end.to change(suspended_user, :suspended_at).to(nil)
      end

      it { expect(response).to have_http_status(:redirect) }
    end

    context "with regular user" do
      include_context "with authenticated user"

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(root_path) }
    end
  end
end
