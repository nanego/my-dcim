# frozen_string_literal: true

require "rails_helper"

RSpec.describe AirConditionerModelsController do
  let(:air_conditioner_model) { air_conditioner_models(:one) }

  describe "GET #index" do
    subject(:response) do
      get air_conditioner_models_url
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }

    it { expect { response }.to have_rubanok_processed(AirConditionerModel.all).with(AirConditionerModelsProcessor) }
  end

  describe "GET #show" do
    subject(:response) do
      get air_conditioner_model_url(air_conditioner_model)
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:show) }
  end

  describe "GET #new" do
    subject(:response) do
      get new_air_conditioner_model_url
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "GET #edit" do
    subject(:response) do
      get edit_air_conditioner_model_url(air_conditioner_model)
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "POST #create" do
    subject(:response) do
      post(air_conditioner_models_url, params:)
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:manufacturer) { manufacturers(:juniper) }
    let(:params) { { air_conditioner_model: { name: "Name", manufacturer_id: manufacturer.id } } }

    include_context "with authenticated user"

    context "with valid parameters" do
      it { expect { response }.to change(AirConditionerModel, :count).by(1) }
      it { expect(response).to redirect_to(air_conditioner_model_url(AirConditionerModel.last)) }
    end

    context "with invalid parameters" do
      let(:params) { { air_conditioner_model: { name: "Name", manufacturer_id: 999 } } }

      it { expect { response }.not_to change(AirConditionerModel, :count) }
      it { expect(response).to have_http_status(:unprocessable_content) }
    end
  end

  describe "PATCH #update" do
    subject(:response) do
      patch(air_conditioner_model_url(air_conditioner_model), params:)
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:air_conditioner_model) { air_conditioner_models(:one) }
    let(:manufacturer) { manufacturers(:juniper) }
    let(:params) { { air_conditioner_model: { name: "New name", manufacturer_id: manufacturer.id } } }

    include_context "with authenticated user"

    context "with valid parameters" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(air_conditioner_model_url(air_conditioner_model)) }

      it do
        expect do
          response
          air_conditioner_model.reload
        end.to change(air_conditioner_model, :name).to("New name")
      end
    end

    context "with invalid parameters" do
      let(:params) { { air_conditioner_model: { name: "new name", manufacturer_id: -1 } } }

      it { expect(response).to have_http_status(:unprocessable_content) }
      it { expect(response).to render_template(:edit) }

      it do
        expect do
          response
          air_conditioner_model.reload
        end.not_to change(air_conditioner_model, :name)
      end
    end
  end

  describe "DELETE #destroy" do
    subject(:response) do
      delete air_conditioner_model_url(air_conditioner_model, params:)
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:air_conditioner_model) { air_conditioner_models(:unused) }
    let(:params) { { confirm: true } }

    include_context "with authenticated user"

    context "without confirm" do
      let(:params) { {} }

      it { expect { response }.not_to change(AirConditionerModel, :count) }
      it { expect(response).to have_http_status(:success) }
      it { expect(AirConditionerModel.exists?(air_conditioner_model.id)).to be true }
    end

    context "with confirm" do
      it { expect { response }.to change(AirConditionerModel, :count).by(-1) }
      it { expect(response).to redirect_to(air_conditioner_models_url) }
    end
  end
end
