# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/domaines" do
  describe "GET /new" do
    subject(:response) do
      get new_domaine_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "POST /create" do
    subject(:response) do
      post(domaines_path, params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { { domaine: { name: "Domaine 1", description: "Description 1" } } }

    include_context "with authenticated user"
    it_behaves_like "with create another one"

    context "with valid parameters" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(domaine_path(assigns(:domaine))) }
      it { expect { response }.to change(Domaine, :count).by(1) }
    end

    context "without attributes" do
      let(:params) { { domaine: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end
  end
end
