# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Visualization::NetworkCapacitiyController" do
  let(:user) { User.create!(email: "user@example.com", password: "passwordpassword", role: "user") }

  before { sign_in user }

  describe "GET #show" do
    before { get visualization_network_capacity_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:show) }
  end
end
