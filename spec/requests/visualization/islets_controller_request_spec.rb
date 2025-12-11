# frozen_string_literal: true

require "rails_helper"

RSpec.describe Visualization::IsletsController do
  let(:islet) { islets(:one) }

  describe "GET #print" do
    subject(:response) do
      get print_visualization_islet_path(islet)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    context "with not found islet" do
      let(:islet) { Islet.new(id: 999_999_999) }

      it { expect { response }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "with existing islet" do
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:print) }
      it { expect(response).to render_template("layouts/pdf") }
    end
  end
end
