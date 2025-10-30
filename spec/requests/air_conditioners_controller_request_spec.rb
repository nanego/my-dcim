# frozen_string_literal: true

require "rails_helper"

RSpec.describe AirConditionersController do
  let(:air_conditioner) { air_conditioners(:one) }

  describe "GET #index" do
    subject(:response) do
      get air_conditioners_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    before { sign_in users(:admin) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }

    it { expect { response }.to have_rubanok_processed(AirConditioner.all).with(AirConditionersProcessor) }

    it do
      response
      expect(assigns(:air_conditioners)).to be_present
    end
  end

  describe "GET #new" do
    subject(:response) do
      get new_air_conditioner_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "POST #create" do
    subject(:response) do
      post(air_conditioners_path, params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) do
      { air_conditioner: { status: :on,
                           position: :left,
                           bay_id: bays(:one).id,
                           air_conditioner_model_id: air_conditioner_models(:one).id } }
    end

    include_context "with authenticated admin"
    it_behaves_like "with create another one"

    context "with valid parameters" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(air_conditioner_path(assigns(:air_conditioner))) }
      it { expect { response }.to change(AirConditioner, :count).by(1) }
    end

    context "with invalid parameters" do
      let(:params) { { air_conditioner: { status: :on, position: "invalid" } } }

      it { expect { response }.to raise_error(ArgumentError) }
    end

    context "without attributes" do
      let(:params) { { air_conditioner: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end
  end
end
