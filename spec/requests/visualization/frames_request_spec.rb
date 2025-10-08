# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Visualization::FramesController" do
  let(:frame) { frames(:one) }

  describe "GET #print" do
    subject(:response) do
      get print_visualization_frame_path(frame)
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    context "with not found frame" do
      let(:frame) { Frame.new(id: 999_999_999) }

      it { expect { response }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "with existing frame" do
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:print) }
      it { expect(response).to render_template("layouts/pdf") }
    end
  end
end
