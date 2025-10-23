# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Visualization::InfrastructuresController" do
  let(:user) do
    User.create!(email: "user@example.com", password: "passwordpassword", permission_scopes: [permission_scopes(:all)])
end

  before { sign_in user }

  describe "GET #show" do
    context "when filter is not filled" do
      before { get visualization_infrastructure_path }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(visualization_infrastructure_path(islet_id: 1, network_type: :gbe)) }
    end
  end
end
