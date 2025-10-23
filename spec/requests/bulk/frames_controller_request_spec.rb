# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bulk::FramesController do
  before { sign_in users(:admin) }

  describe "DELETE #destroy" do
    subject(:response) do
      delete bulk_frames_path(ids:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    context "with frames without associations" do
      let(:ids) { [frame_a.id, frame_b.id] }
      let!(:frame_a) { Frame.create!(bay: bays(:one)) }
      let!(:frame_b) { Frame.create!(bay: bays(:two)) }

      it { expect { response }.to have_authorized_scope(:active_record_relation).with(FramePolicy) }
      it { expect { response }.to change(Frame, :count).by(-2) }
      it { expect(response).to redirect_to(frames_path) }
    end

    context "with a frame with associations" do
      let(:ids) { [frames(:one).id] }

      it { expect { response }.to have_authorized_scope(:active_record_relation).with(FramePolicy) }
      it { expect { response }.not_to change(Frame, :count) }
      it { expect(response).to redirect_to(frames_path) }
    end
  end
end
