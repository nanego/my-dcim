# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::Settings" do
  let(:user) { User.create!(email: "user@example.com", password: "passwordpassword", role: "user") }
  let(:params) { { user: { locale: "fr" } } }

  before { sign_in user }

  describe "GET #edit" do
    before { get edit_users_settings_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "PATCH #update" do
    subject(:response) do
      patch(users_settings_path(user), params:)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "with invalid data" do
      let(:params) { { user: { locale: "test", theme: "yellow" } } }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response).to render_template(:edit) }
    end

    context "with valid parameters" do
      it { expect(response).to redirect_to(edit_users_settings_path) }

      it do
        expect do
          response
          user.reload
        end.to change(user, :locale).to("fr")
      end
    end
  end
end
