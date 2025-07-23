# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/sites" do
  describe "GET #new" do
    subject(:response) do
      get new_site_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "POST #create" do
    subject(:response) do
      post(sites_path, params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { { site: { name: "Site 1" } } }

    include_context "with authenticated user"
    it_behaves_like "with create another one"

    context "with valid parameters" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(site_path(assigns(:site))) }
      it { expect { response }.to change(Site, :count).by(1) }
    end

    context "without attributes" do
      let(:params) { { site: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "with invalid parameters" do
      let(:params) { { site: { delivery_map: } } }

      let(:delivery_map) { Rack::Test::UploadedFile.new("spec/fixtures/files/text.txt", "text/txt") }

      it { expect(response).to render_template(:new) }
      it { expect { response }.not_to change(Site, :count) }
    end
  end
end
