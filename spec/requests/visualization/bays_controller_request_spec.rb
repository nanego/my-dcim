# frozen_string_literal: true

require "rails_helper"

RSpec.describe Visualization::BaysController do
  let(:bay) { bays(:one) }

  describe "GET #show" do
    subject(:response) do
      get visualization_bay_path(bay, params:)
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { {} }

    include_context "with authenticated admin"

    context "with not found bay" do
      let(:bay) { Bay.new(id: 999_999_999) }

      it { expect { response }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "with existing bay" do
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:show) }
      it { expect(response.body).to include(bay.islet.name) }

      it :aggregate_failures do
        response

        expect(assigns(:servers_per_frames)).to be_present
        expect(assigns(:bay)).to be_present
      end
    end
  end

  describe "GET #print" do
    subject(:response) do
      get print_visualization_bay_path(bay, format:)
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:format) { nil }

    include_context "with authenticated admin"

    context "with not found bay" do
      let(:bay) { Bay.new(id: 999_999_999) }

      it { expect { response }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "with existing bay" do
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:print) }
      it { expect(response).to render_template("layouts/pdf") }

      it :aggregate_failures do
        response

        expect(assigns(:servers_per_frames)).to be_present
        expect(assigns(:bay)).to be_present
      end
    end

    context "with pdf format" do
      let(:format) { :pdf }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:print) }
      it { expect(response).to render_template("layouts/pdf") }
      it { expect(response.headers["Content-Type"]).to eq("application/pdf") }
    end
  end
end
