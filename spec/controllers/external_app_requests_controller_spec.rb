require 'rails_helper'

RSpec.describe ExternalAppRequestsController, type: :controller do

  fixtures :users

  before do
    sign_in users(:one)
  end

  let(:request) { ExternalAppRequest.create!(user: User.first, external_app_name: 'glpi') }

  describe "GET #show" do
    it "returns the request status and progress" do
      get :show, params: { id: request.id }
      json_response = JSON.parse(response.body)
      expect(json_response).to include('status' => request.status,
                                       'progress' => request.progress)
    end
  end
end
