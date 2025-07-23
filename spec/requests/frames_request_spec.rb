# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Frames" do
  let(:frame) { frames(:one) }
  let(:coupled_frame) { frames(:two) }
  let(:network_frame) { frames(:three) }

  describe "GET #new" do
    subject(:response) do
      get new_frame_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "POST #create" do
    subject(:response) do
      post(frames_path, params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { { frame: { name: "Frame 1", bay_id: bays(:one).id } } }

    include_context "with authenticated user"
    it_behaves_like "with create another one"

    context "with valid parameters" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(frame_path(assigns(:frame))) }
      it { expect { response }.to change(Frame, :count).by(1) }
    end

    context "with invalid parameters" do
      let(:params) { { frame: { name: "Frame 1", bay_id: 9999 } } }

      it { expect(response).to render_template(:new) }
      it { expect { response }.not_to change(Frame, :count) }
    end

    context "without attributes" do
      let(:params) { { frame: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end
  end

  describe "GET #network" do
    subject(:response) do
      get network_frame_path(frame, network_frame_id: network_frame.slug)
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { is_expected.to have_http_status(:success) }
    it { is_expected.to render_template(:network) }

    context 'when frame is the coupled frame' do
      subject(:response) do
        get network_frame_path(coupled_frame, network_frame_id: network_frame.slug)
        @response # rubocop:disable RSpec/InstanceVariable
      end

      it 'renders successfully' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'with non-existent frame' do
      it 'raises not found error' do
        expect do
          get network_frame_path('non-existent-frame', network_frame_id: network_frame.slug)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "GET #print" do
    subject(:response) do
      get print_visualization_frame_path(frame)
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

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
