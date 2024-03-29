# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Users" do
  let(:admin_user) { User.create!(email: "user@example.com", password: "passwordpassword", role: "admin") }

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
