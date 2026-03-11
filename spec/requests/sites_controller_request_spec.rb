# frozen_string_literal: true

require "rails_helper"

RSpec.describe SitesController do
  let(:site) { sites(:one) }

  describe "GET #index" do
    subject(:response) do
      get sites_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    before { sign_in users(:admin) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }

    it { expect { response }.to have_authorized_scope(:active_record_relation).with(SitePolicy) }
    it { expect { response }.to have_rubanok_processed(Site.all).with(SitesProcessor) }

    it do
      response
      expect(assigns(:sites)).to be_present
    end
  end

  describe "GET #show" do
    subject(:response) do
      get site_path(site)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:show) }
  end

  describe "GET #new" do
    subject(:response) do
      get new_site_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

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

    include_context "with authenticated admin"
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

  describe "GET #print" do
    subject(:response) do
      get print_site_path(site)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:print) }
    it { expect(response).to render_template("layouts/pdf") }
    it { expect(response.headers["Content-Type"]).to eq("application/pdf") }
  end
end
