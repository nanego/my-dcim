# frozen_string_literal: true

require "rails_helper"

RSpec.describe IsletsController do
  let(:islet) { islets(:one) }

  describe "GET #index" do
    subject(:response) do
      get islets_path

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(islet.name) }

    it { expect { response }.to have_authorized_scope(:active_record_relation).with(IsletPolicy) }
    it { expect { response }.to have_rubanok_processed(Islet.all).with(IsletsProcessor) }
  end

  describe "GET #show" do
    subject(:response) do
      get islet_path(islet)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    context "with not found islet" do
      let(:islet) { Islet.new(id: 999_999_999) }

      it { expect { response }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "with existing islet" do
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:show) }

      it :aggregate_failures do
        response
        expect(assigns(:room)).to be_present
        expect(assigns(:islet)).to be_present
      end
    end
  end

  describe "GET #new" do
    subject(:response) do
      get new_islet_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "POST #create" do
    subject(:response) do
      post islets_path, params: params

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:valid_attributes) { { name: "New Islet", room_id: islet.room_id } }
    let(:invalid_attributes) { { name: "" } }
    let(:params) { { islet: valid_attributes } }

    include_context "with authenticated admin"
    it_behaves_like "with create another one"

    context "with valid parameters" do
      it { expect { response }.to change(Islet, :count).by(1) }
      it { expect(response).to redirect_to(islet_path(assigns(:islet))) }
    end

    context "without attributes" do
      let(:params) { { islet: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "with invalid parameters" do
      let(:params) { { islet: invalid_attributes } }

      it { expect(response).to render_template(:new) }
    end
  end

  describe "GET #edit" do
    subject(:response) do
      get edit_islet_path(islet)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "PATCH #update" do
    subject(:response) do
      patch islet_path(islet), params: params

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:valid_attributes) { { room_id: "2" } }
    let(:invalid_attributes) { { room_id: "" } }
    let(:params) { { islet: valid_attributes } }

    include_context "with authenticated admin"

    context "with valid parameters" do
      it do
        expect do
          response
          islet.reload
        end.to change(islet, :room_id).to(2)
      end

      it { expect(response).to redirect_to(islet) }
      it { expect(response).to have_http_status(:redirect) }
    end

    context "without attributes" do
      let(:params) { { islet: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "with invalid parameters" do
      let(:params) { { islet: invalid_attributes } }

      it { expect(response).to render_template(:edit) }
    end
  end

  describe "DELETE #destroy" do
    subject(:response) do
      delete islet_path(islet, confirm: true)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    context "without confirm" do
      subject(:response) do
        delete islet_path(islet)
        @response # rubocop:disable RSpec/InstanceVariable
      end

      it do
        expect do
          response
        end.not_to change(Islet, :count)
      end

      it { expect(response).to have_http_status(:success) }
      it { expect(Islet.exists?(islet.id)).to be true }
    end

    context "with an islet without bays" do
      let(:islet) { islets(:three) }

      it do
        expect do
          response
        end.to change(Islet, :count).by(-1)
      end

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(islets_path) }
    end

    context "with an islet with bays" do
      it do
        expect do
          response
        end.not_to change(Islet, :count)
      end

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(islets_path) }
    end
  end
end
