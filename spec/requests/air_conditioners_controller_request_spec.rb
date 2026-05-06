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

  describe "GET #show" do
    subject(:response) do
      get air_conditioner_path(air_conditioner)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:show) }
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

  describe "GET #edit" do
    subject(:response) do
      get edit_air_conditioner_path(air_conditioner)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "PATCH #update" do
    subject(:response) do
      patch(air_conditioner_path(air_conditioner), params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) do
      { air_conditioner: { status: :on } }
    end

    include_context "with authenticated admin"

    context "with valid parameters" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(air_conditioner_path(assigns(:air_conditioner))) }

      it do
        expect do
          response
          air_conditioner.reload
        end.to change(air_conditioner, :status).to("on")
      end
    end

    context "with invalid parameters" do
      let(:params) { { air_conditioner: { air_conditioner_model_id: 999 } } }

      it { expect(response).to render_template(:edit) }

      it do
        expect do
          response
          air_conditioner.reload
        end.not_to change(air_conditioner, :status)
      end
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

  describe "DELETE #destroy" do
    subject(:response) do
      delete air_conditioner_path(air_conditioner, confirm: true, params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { {} }

    include_context "with authenticated admin"

    context "without confirm" do
      subject(:response) do
        delete(air_conditioner_path(air_conditioner), params:)
        @response # rubocop:disable RSpec/InstanceVariable
      end

      it { expect { response }.not_to change(AirConditioner, :count) }
      it { expect(response).to have_http_status(:success) }
      it { expect(AirConditioner.exists?(air_conditioner.id)).to be true }
    end

    context "with confirm" do
      it { expect { response }.to change(AirConditioner, :count) }
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(air_conditioners_path) }
    end

    context "when request back on succes" do
      let(:params) { { back_to: "/some_path" } }

      it { expect(response).to redirect_to("/some_path") }
      it { expect { response }.to change(AirConditioner, :count).by(-1) }
    end
  end
end
