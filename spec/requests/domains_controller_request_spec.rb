# frozen_string_literal: true

require "rails_helper"

RSpec.describe DomainsController do
  let(:domain) { domains(:stock) }

  describe "GET #index" do
    subject(:response) do
      get domains_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    before { sign_in users(:admin) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }

    it { expect { response }.to have_authorized_scope(:active_record_relation).with(DomainPolicy) }
    it { expect { response }.to have_rubanok_processed(Domain.sorted).with(DomainsProcessor) }

    it do
      response
      expect(assigns(:domains)).to be_present
    end
  end

  describe "GET #show" do
    subject(:response) do
      get domain_path(domain)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:show) }
  end

  describe "GET #new" do
    subject(:response) do
      get new_domain_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "POST #create" do
    subject(:response) do
      post(domains_path, params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { { domain: { name: "Domain 1", description: "Description 1" } } }

    include_context "with authenticated admin"
    it_behaves_like "with create another one"

    context "with valid parameters" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(domain_path(assigns(:domain))) }
      it { expect { response }.to change(Domain, :count).by(1) }
    end

    context "without attributes" do
      let(:params) { { domain: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end
  end
end
