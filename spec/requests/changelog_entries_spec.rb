require 'rails_helper'

RSpec.describe "ChangelogEntries", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/changelog_entries/index"
      expect(response).to have_http_status(:success)
    end
  end

end
