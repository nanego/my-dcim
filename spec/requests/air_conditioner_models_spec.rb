# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/air_conditioner_models" do
  let(:air_conditioner_model) { air_conditioner_models(:one) }

  describe "GET /index" do
    subset(:response) do
      get air_conditioner_models_url
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }

    it { expect { response }.to have_rubanok_processed(AirConditionerModel.all).with(AirConditionerModelsProcessor) }
  end

  describe "GET /show" do
    subset(:response) do
      get air_conditioner_model_url(air_conditioner_model)
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:show) }
  end

  describe "GET /new" do
    subset(:response) do
      get new_air_conditioner_model_url
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "GET /edit" do
    subset(:response) do
      get edit_air_conditioner_model_url(air_conditioner_model)
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new AirConditionerModel" do
        expect do
          post air_conditioner_models_url, params: { air_conditioner_model: valid_attributes }
        end.to change(AirConditionerModel, :count).by(1)
      end

      it "redirects to the created air_conditioner_model" do
        post air_conditioner_models_url, params: { air_conditioner_model: valid_attributes }
        expect(response).to redirect_to(air_conditioner_model_url(AirConditionerModel.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new AirConditionerModel" do
        expect do
          post air_conditioner_models_url, params: { air_conditioner_model: invalid_attributes }
        end.not_to change(AirConditionerModel, :count)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post air_conditioner_models_url, params: { air_conditioner_model: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        skip("Add a hash of attributes valid for your model")
      end

      it "updates the requested air_conditioner_model" do
        air_conditioner_model = AirConditionerModel.create! valid_attributes
        patch air_conditioner_model_url(air_conditioner_model), params: { air_conditioner_model: new_attributes }
        air_conditioner_model.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the air_conditioner_model" do
        air_conditioner_model = AirConditionerModel.create! valid_attributes
        patch air_conditioner_model_url(air_conditioner_model), params: { air_conditioner_model: new_attributes }
        air_conditioner_model.reload
        expect(response).to redirect_to(air_conditioner_model_url(air_conditioner_model))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        air_conditioner_model = AirConditionerModel.create! valid_attributes
        patch air_conditioner_model_url(air_conditioner_model), params: { air_conditioner_model: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested air_conditioner_model" do
      air_conditioner_model = AirConditionerModel.create! valid_attributes
      expect do
        delete air_conditioner_model_url(air_conditioner_model)
      end.to change(AirConditionerModel, :count).by(-1)
    end

    it "redirects to the air_conditioner_models list" do
      air_conditioner_model = AirConditionerModel.create! valid_attributes
      delete air_conditioner_model_url(air_conditioner_model)
      expect(response).to redirect_to(air_conditioner_models_url)
    end
  end
end
