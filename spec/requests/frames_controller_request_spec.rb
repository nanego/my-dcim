# frozen_string_literal: true

require "rails_helper"

RSpec.describe FramesController do
  let(:frame) { frames(:one) }

  describe "GET #index" do
    subject(:response) do
      get frames_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    before { sign_in users(:admin) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }

    it { expect { response }.to have_authorized_scope(:active_record_relation).with(FramePolicy) }
    it { expect { response }.to have_rubanok_processed(Frame.all).with(FramesProcessor) }

    it do
      response
      expect(assigns(:frames)).to be_present
    end
  end

  describe "GET #show" do
    subject(:response) do
      get frame_path(frame)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:show) }
  end

  describe "GET #new" do
    subject(:response) do
      get new_frame_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

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

    include_context "with authenticated admin"
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

    context "when request back on succes" do
      let(:params) do
        {
          frame: { name: "Frame 1", bay_id: bays(:one).id },
          redirect_to_on_success: visualization_rooms_path,
        }
      end

      it { expect(response).to redirect_to(visualization_rooms_path) }

      it do
        expect do
          response
        end.to change(Frame, :count).by(1)
      end
    end
  end

  describe "GET #edit" do
    subject(:response) do
      get edit_frame_path(frame)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "PATCH #update" do
    subject(:response) do
      patch(frame_path(frame), params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) do
      { frame: { name: "New Frame name" } }
    end

    include_context "with authenticated admin"

    context "with valid parameters" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(frame_path(assigns(:frame))) }

      it do
        expect do
          response
          frame.reload
        end.to change(frame, :name).to("New Frame name")
      end
    end

    context "with invalid parameters" do
      let(:params) { { frame: { name: "Frame 1", bay_id: nil } } }

      it { expect(response).to render_template(:edit) }

      it do
        expect do
          response
          frame.reload
        end.not_to change(frame, :name)
      end
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

  describe "DELETE #destroy" do
    subject(:response) do
      delete frame_path(frame, confirm: true)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    context "without confirm" do
      subject(:response) do
        delete frame_path(frame)
        @response # rubocop:disable RSpec/InstanceVariable
      end

      it do
        expect do
          response
        end.not_to change(Frame, :count)
      end

      it { expect(response).to have_http_status(:success) }
      it { expect(Frame.exists?(frame.id)).to be true }
    end

    context "with frame without any IT equipments" do
      let(:frame) { frames(:two) }

      it do
        expect do
          response
        end.to change(Frame, :count).by(-1)
      end

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(frames_path) }
    end

    context "with frame with IT equipments" do
      it do
        expect do
          response
        end.not_to change(Frame, :count)
      end

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(frames_path) }
    end
  end
end
