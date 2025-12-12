# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Visualization::FramesController" do
  let(:frame) { frames(:one) }
  let(:coupled_frame) { frames(:two) }
  let(:network_frame) { frames(:three) }

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

  describe "GET #network" do
    subject(:response) do
      get network_visualization_frame_path(frame, network_frame_id: network_frame.slug)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:network) }

    context "when frame is the coupled frame" do
      subject(:response) do
        get network_visualization_frame_path(coupled_frame, network_frame_id: network_frame.slug)
        @response # rubocop:disable RSpec/InstanceVariable
      end

      it "renders successfully" do
        expect(response).to have_http_status(:success)
      end
    end

    context "with non-existent frame" do
      it "raises not found error" do
        expect do
          get network_visualization_frame_path("non-existent-frame", network_frame_id: network_frame.slug)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
