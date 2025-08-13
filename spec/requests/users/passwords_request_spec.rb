# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SearchController" do
  describe "GET /new" do
    it do
      get new_user_password_path

      expect(response).to have_http_status(:ok)
    end
  end
end
