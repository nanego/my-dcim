require 'rails_helper'

RSpec.describe ExternalAppRecordsController, type: :controller do

  fixtures :users

  before do
    sign_in users(:one)
  end

  describe "PUT #sync_all_servers_with_glpi" do
    it "creates a new request and enqueues the job" do
      expect {
        put :sync_all_servers_with_glpi
      }.to change(ExternalAppRequest, :count).by(1)

      expect(SyncWithGlpiJob).to have_been_enqueued

      request = ExternalAppRequest.last
      json_response = JSON.parse(response.body)
      expect(json_response).to include('request_id' => request.id,
                                       'status' => "pending",
                                       'progress' => 0)
    end
  end
end
