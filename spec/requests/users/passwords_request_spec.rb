# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::PasswordsController" do
  describe "GET #new" do
    before { get new_user_password_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end
end
