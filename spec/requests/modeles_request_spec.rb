# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/modeles" do
  let(:modele) { modeles(:one) }

  describe "GET #index" do
    subject(:response) do
      get modeles_path

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    before { response }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(modele.name) }
    it { expect(assigns(:modeles)).not_to be_nil }
  end

  describe "GET #show" do
    subject(:response) do
      get modele_path(modele)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    context "with not found modele" do
      let(:modele) { Modele.new(id: 999_999_999) }

      it { expect { response }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "with existing modele" do
      before { response }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:show) }
      it { expect(assigns(:modele).enclosures.length).to eq 2 }
    end
  end

  describe "GET #new" do
    subject(:response) do
      get new_modele_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "POST #create" do
    subject(:response) do
      post modeles_path, params: params

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:valid_attributes) do
      {
        name: "New Modele",
        category_id: modele.category_id,
        architecture_id: modele.architecture_id,
        manufacturer_id: modele.manufacturer_id
      }
    end
    let(:invalid_attributes) { { name: "" } }
    let(:params) { { modele: valid_attributes } }

    include_context "with authenticated user"

    context "with valid parameters" do
      it { expect { response }.to change(Modele, :count).by(1) }
      it { expect(response).to redirect_to(modele_path(assigns(:modele))) }
    end

    context "without attributes" do
      let(:params) { { modele: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "with invalid parameters" do
      let(:params) { { modele: invalid_attributes } }

      it { expect { response }.not_to change(Modele, :count) }
      it { expect(response).to render_template(:new) }
    end

    context "when preview button clicked with turbo_stream format" do
      let(:params) do
        {
          modele: { name: "Modele" },
          preview: "preview",
          format: :turbo_stream
        }
      end

      it { expect(response).to render_template(:preview) }
      it { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end

  describe "GET #edit" do
    subject(:response) do
      get edit_modele_path(modele)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    before { response }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
    it { expect(assigns(:modele).color).not_to be_nil }
  end

  describe "PATCH #update" do
    subject(:response) do
      patch modele_path(modele), params: params

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:valid_attributes) { { category_id: "2" } }
    let(:invalid_attributes) { { category_id: "" } }
    let(:params) { { modele: valid_attributes } }

    include_context "with authenticated user"

    context "with valid parameters" do
      it do
        expect do
          response
          modele.reload
        end.to change(modele, :category_id).to(2)
      end

      it { expect(response).to redirect_to(modele_path(assigns(:modele))) }
      it { expect(response).to have_http_status(:redirect) }
    end

    context "without attributes" do
      let(:params) { { modele: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "with invalid parameters" do
      let(:params) { { modele: invalid_attributes } }

      it { expect(response).to render_template(:edit) }
    end

    context "when preview button clicked with turbo_stream format" do
      let(:params) do
        {
          modele: { name: "Modele" },
          preview: "preview",
          format: :turbo_stream
        }
      end

      it { expect(response).to render_template(:preview) }
      it { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end

  describe "DELETE #destroy" do
    subject(:response) do
      delete modele_path(modele)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    context "with a modele not referenced on Server" do
      let(:modele) { modeles(:four) }

      it do
        expect do
          response
        end.to change(Modele, :count).by(-1)
      end

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(modeles_path) }
    end

    context "with an modele referenced on at least one Server" do
      it do
        expect do
          response
        end.not_to change(Modele, :count)
      end

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(modeles_path) }
    end
  end

  describe "GET #duplicate" do
    subject(:response) do
      get duplicate_modele_path(modele)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:duplicate) }
  end
end
