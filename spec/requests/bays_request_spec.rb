# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Bays" do
  let(:bay) { bays(:one) }

  describe "GET #index" do
    before do
      sign_in users(:one)

      get bays_path
    end

    it_behaves_like "with preferred columns", BaysController::AVAILABLE_COLUMNS

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
  end

  describe "GET #new" do
    subject(:response) do
      get new_bay_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

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

    include_context "with authenticated user"
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
  end

  describe "GET #print" do
    subject(:response) do
      get print_visualization_bay_path(bay)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

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
