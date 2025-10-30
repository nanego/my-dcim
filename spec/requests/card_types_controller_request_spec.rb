# frozen_string_literal: true

require "rails_helper"

RSpec.describe CardTypesController do
  let(:card_type) { card_types(:one) }

  describe "GET #index" do
    subject(:response) do
      get card_types_path

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(card_type.name) }

    it { expect { response }.to have_rubanok_processed(CardType.all).with(CardTypesProcessor) }

    it do
      response
      expect(assigns(:card_types)).not_to be_nil
    end
  end

  describe "GET #show" do
    subject(:response) do
      get card_type_path(card_type)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    context "with not found card_type" do
      let(:card_type) { CardType.new(id: 999_999_999) }

      it { expect { response }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "with existing card_type" do
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:show) }
    end
  end

  describe "GET #new" do
    subject(:response) do
      get new_card_type_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "POST #create" do
    subject(:response) do
      post card_types_path, params: params

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:valid_attributes) { { name: "New CardType", port_type_id: card_type.port_type_id } }
    let(:invalid_attributes) { { name: "" } }
    let(:params) { { card_type: valid_attributes } }

    include_context "with authenticated admin"
    it_behaves_like "with create another one"

    context "with valid parameters" do
      it { expect { response }.to change(CardType, :count).by(1) }
      it { expect(response).to redirect_to(card_type_path(assigns(:card_type))) }
    end

    context "without attributes" do
      let(:params) { { card_type: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "with invalid parameters" do
      let(:params) { { card_type: invalid_attributes } }

      it { expect(response).to render_template(:new) }
    end
  end

  describe "GET #edit" do
    subject(:response) do
      get edit_card_type_path(card_type)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "PATCH #update" do
    subject(:response) do
      patch card_type_path(card_type), params: params

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:valid_attributes) { { port_type_id: "2" } }
    let(:invalid_attributes) { { port_type_id: "" } }
    let(:params) { { card_type: valid_attributes } }

    include_context "with authenticated admin"

    context "with valid parameters" do
      it do
        expect do
          response
          card_type.reload
        end.to change(card_type, :port_type_id).to(2)
      end

      it { expect(response).to redirect_to(card_type_path(assigns(:card_type))) }
      it { expect(response).to have_http_status(:redirect) }
    end

    context "without attributes" do
      let(:params) { { card_type: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "with invalid parameters" do
      let(:params) { { card_type: invalid_attributes } }

      it { expect(response).to render_template(:edit) }
    end
  end

  describe "DELETE #destroy" do
    subject(:response) do
      delete card_type_path(card_type)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    context "with an card_type without cards" do
      let(:card_type) { card_types(:three) }

      it do
        expect do
          response
        end.to change(CardType, :count).by(-1)
      end

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(card_types_path) }
    end

    context "with an card_type with cards" do
      it do
        expect do
          response
        end.not_to change(CardType, :count)
      end

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(card_types_path) }
    end
  end
end
