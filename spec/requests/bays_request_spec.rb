# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Bays" do
  let(:bay) { bays(:one) }

  describe "GET #index" do
    before do
      sign_in users(:one)

      get servers_path
    end

    include_examples "with preferred columns", BaysController::AVAILABLE_COLUMNS

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
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
