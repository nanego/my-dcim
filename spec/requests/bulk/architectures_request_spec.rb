# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/architectures" do
  before { sign_in users(:one) }

  describe "DELETE /destroy" do
    context "with architectures without associations" do
      it do
        expect do
          delete bulk_architectures_path(ids: [architectures(:tour).id, architectures(:three).id])
        end.to change(Architecture, :count).by(-2)
      end

      it do
        delete bulk_architectures_path(ids: [architectures(:tour).id, architectures(:three).id])
        expect(response).to redirect_to(architectures_path)
      end
    end

    context "with an architecture with associations" do
      it do
        expect do
          delete bulk_architectures_path(ids: [architectures(:rackable).id])
        end.not_to change(Frame, :count)
      end

      it do
        delete bulk_architectures_path(ids: [architectures(:rackable).id])
        expect(response).to redirect_to(architectures_path)
      end
    end
  end
end
