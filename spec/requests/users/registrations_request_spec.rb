# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::Registrations" do
  let(:current_user) { users(:admin) }
  let(:user) { users(:one) }

  before { sign_in current_user }

  describe "GET /edit_user" do
    subject(:response) do
      get(edit_user_registration_path(user_id: user.id))

      @response # rubocop:disable RSpec/InstanceVariable
    end

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }

    context "when current user is not admin" do
      let(:current_user) { users(:one) }

      it { expect { response }.to raise_error(ActionPolicy::Unauthorized) }
    end
  end

  describe "PATCH /update_user" do
    subject(:response) do
      patch(user_registration_path(user_id: user.id, params:))

      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { { user: { name: "newFirstName" } } }

    context "with valid data" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(user_path(user)) } # rubocop:disable RSpec/EmptyLineAfterExample
      it do
        expect do
          response
          user.reload
        end.to change(user, :name).from("User1").to("newFirstName")
      end
    end

    context "with invalid data" do
      let(:params) { { user: { email: "" } } }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response).to render_template(:edit) }
      it { expect { response }.not_to change(user, :email) }
    end

    context "when current user is not admin" do
      let(:current_user) { users(:one) }

      it { expect { response }.to raise_error(ActionPolicy::Unauthorized) }
    end
  end
end
