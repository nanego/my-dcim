# frozen_string_literal: true

require "rails_helper"

RSpec.describe BaysController do
  let(:bay) { bays(:one) }

  describe "GET #index" do
    before do
      sign_in users(:admin)

      get bays_path
    end

    it_behaves_like "with preferred columns", BaysController::AVAILABLE_COLUMNS, route: :bays_path

    it { expect { response }.to have_authorized_scope(:active_record_relation).with(BayPolicy) }
    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(assigns(:bays)).to be_present }
  end

  describe "GET #show" do
    subject(:response) do
      get bay_path(bay)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:show) }
  end

  describe "GET #new" do
    subject(:response) do
      get new_bay_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "POST #create" do
    subject(:response) do
      post(bays_path, params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) do
      { bay: { name: "Bay 1", bay_type_id: bay_types(:one).id, islet_id: islets(:one).id } }
    end

    include_context "with authenticated admin"
    it_behaves_like "with create another one"

    context "with valid parameters" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(bay_path(assigns(:bay))) }
      it { expect { response }.to change(Bay, :count).by(1) }
    end

    context "with invalid parameters" do
      let(:params) { { bay: { name: "Bay 1", bay_type_id: 9999 } } }

      it { expect(response).to render_template(:new) }
      it { expect { response }.not_to change(Bay, :count) }
    end

    context "without attributes" do
      let(:params) { { bay: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "when request back on succes" do
      let(:params) do
        {
          bay: { name: "Bay 1", bay_type_id: bay_types(:one).id, islet_id: islets(:one).id },
          redirect_to_on_success: overview_rooms_path,
        }
      end

      it { expect(response).to redirect_to(overview_rooms_path) }

      it do
        expect do
          response
        end.to change(Bay, :count).by(1)
      end
    end
  end

  describe "GET #edit" do
    subject(:response) do
      get edit_bay_path(bay)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "PATCH #update" do
    subject(:response) do
      patch(bay_path(bay), params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) do
      { bay: { name: "New Bay name" } }
    end

    include_context "with authenticated admin"

    context "with valid parameters" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(bay_path(assigns(:bay))) }

      it do
        expect do
          response
          bay.reload
        end.to change(bay, :name).to("New Bay name")
      end
    end

    context "with invalid parameters" do
      let(:params) { { bay: { name: "Bay 1", bay_type_id: 9999 } } }

      it { expect(response).to render_template(:edit) }

      it do
        expect do
          response
          bay.reload
        end.not_to change(bay, :name)
      end
    end

    context "without attributes" do
      let(:params) { { bay: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end
  end

  describe "DELETE #destroy" do
    subject(:response) do
      delete bay_path(bay), params:, headers: { REFERER: "/rooms/overview" }

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { {} }

    include_context "with authenticated admin"

    context "with bay without any frames" do
      let(:bay) { bays(:three) }

      it do
        expect do
          response
        end.to change(Bay, :count).by(-1)
      end

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(bays_path) }
    end

    context "with bay with frames" do
      it do
        expect do
          response
        end.not_to change(Bay, :count)
      end

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(bays_path) }
    end

    context "when request back on succes" do
      let(:bay) { bays(:three) }
      let(:params) { { redirect_to_on_success: :back } }

      it { expect(response).to redirect_to(overview_rooms_path) }

      it do
        expect do
          response
        end.to change(Bay, :count).by(-1)
      end
    end

    context "when request back on failure" do
      let(:params) { { redirect_to_on_success: :back } }

      it { expect(response).to redirect_to(overview_rooms_path) }

      it do
        expect do
          response
        end.not_to change(Bay, :count)
      end
    end
  end

  describe "GET #print" do
    subject(:response) do
      get print_visualization_bay_path(bay)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    context "with not found bay" do
      let(:bay) { Bay.new(id: 999_999_999) }

      it { expect { response }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "with existing bay" do
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:print) }
      it { expect(response).to render_template("layouts/pdf") }
    end
  end
end
