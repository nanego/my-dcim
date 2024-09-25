require 'rails_helper'

RSpec.describe "SearchController", type: :request do
  describe "GET /index" do

    fixtures :servers, :frames

    before do
      sign_in users(:one)
    end

    context "when query is present" do
      let!(:server_1) { servers(:one) }
      let!(:frame_1) { frames(:one) }

      it "returns matching servers and frames in HTML format" do
        get search_path, params: { query: 'A' }, headers: { 'ACCEPT' => 'text/html' }

        expect(response).to have_http_status(:ok)
        expect(assigns(:results)[:servers]).to include(server_1)
        expect(assigns(:results)[:frames]).to include(frame_1)
      end

      it "returns no results when query does not match any object" do
        get search_path, params: { query: 'UnknownSever' }

        expect(response).to have_http_status(:ok)
        expect(assigns(:results)[:servers]).to be_empty
        expect(assigns(:results)[:frames]).to be_empty
      end

    end

    context "when query is not present" do
      it "returns no results" do
        get search_path

        expect(response).to have_http_status(:ok)
        expect(assigns(:results)[:servers]).to be_empty
        expect(assigns(:results)[:frames]).to be_empty
      end
    end
  end
end
