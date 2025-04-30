# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/frames" do
  before { sign_in users(:one) }

  describe "DELETE /destroy" do
    context "with frames without associations" do
      it do
        expect do
          delete bulk_frames_path(ids: [frames(:two).id, frames(:six).id])
        end.to change(Frame, :count).by(-2)
      end

      it do
        delete bulk_frames_path(ids: [frames(:two).id, frames(:six).id])
        expect(response).to redirect_to(frames_path)
      end
    end

    context "with a frame with associations" do
      it do
        expect do
          delete bulk_frames_path(ids: [frames(:one).id])
        end.not_to change(Frame, :count)
      end

      it do
        delete bulk_frames_path(ids: [frames(:one).id])
        expect(response).to redirect_to(frames_path)
      end
    end
  end
end
