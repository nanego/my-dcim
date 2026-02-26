# frozen_string_literal: true

require "rails_helper"

RSpec.describe StacksController do
  let(:stack) { stacks(:red) }

  describe "GET #index" do
    subject(:response) do
      get stacks_path

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(stack.name) }
    it { expect { response }.to have_rubanok_processed(Stack.all).with(StacksProcessor) }
  end

  describe "GET #show" do
    subject(:response) do
      get stack_path(stack)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    context "with not found stack" do
      let(:stack) { Stack.new(id: 999_999_999) }

      it { expect { response }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "with existing stack" do
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:show) }
    end
  end

  describe "GET #new" do
    subject(:response) do
      get new_stack_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "POST #create" do
    subject(:response) do
      post stacks_path, params: params

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:valid_attributes) { { name: "New Stack" } }
    let(:params) { { stack: valid_attributes } }

    include_context "with authenticated admin"

    it_behaves_like "with create another one"

    context "with valid parameters" do
      it { expect { response }.to change(Stack, :count).by(1) }
      it { expect(response).to redirect_to(stack_path(assigns(:stack))) }
    end

    context "without attributes" do
      let(:params) { { stack: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end
  end

  describe "GET #edit" do
    subject(:response) do
      get edit_stack_path(stack)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "PATCH #update" do
    subject(:response) do
      patch stack_path(stack), params: params

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:valid_attributes) { { name: "Blue" } }
    let(:params) { { stack: valid_attributes } }

    include_context "with authenticated admin"

    context "with valid parameters" do
      it do
        expect do
          response
          stack.reload
        end.to change(stack, :name).to("Blue")
      end

      it { expect(response).to redirect_to(stack_path(assigns(:stack))) }
      it { expect(response).to have_http_status(:redirect) }
    end

    context "without attributes" do
      let(:params) { { stack: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end
  end

  describe "DELETE #destroy" do
    subject(:response) do
      delete stack_path(stack, confirm: true)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    context "without confirm" do
      subject(:response) do
        delete stack_path(stack)
        @response # rubocop:disable RSpec/InstanceVariable
      end

      it do
        expect do
          response
        end.not_to change(Stack, :count)
      end

      it { expect(response).to have_http_status(:success) }
      it { expect(Stack.exists?(stack.id)).to be true }
    end

    context "with an stack without servers" do
      let(:stack) { stacks(:orange) }

      it do
        expect do
          response
        end.to change(Stack, :count).by(-1)
      end

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(stacks_path) }
    end

    context "with an stack with servers" do
      it do
        expect do
          response
        end.not_to change(Stack, :count)
      end

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(stacks_path) }
    end
  end
end
