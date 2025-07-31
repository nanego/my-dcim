# frozen_string_literal: true

RSpec.shared_context "with authenticated user" do
  let(:user) { User.create!(email: "user@example.com", password: "passwordpassword", is_admin: true) }
  let(:_keep_user_logged_out) { false }

  context "with logged out user" do
    let(:_keep_user_logged_out) { true }

    it { expect(response).to have_http_status(:redirect) }
    it { expect(response).to redirect_to(new_user_session_path) }
  end

  before do
    sign_in(user) unless _keep_user_logged_out
  end
end
