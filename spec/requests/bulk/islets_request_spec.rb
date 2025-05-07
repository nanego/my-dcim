# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/islets" do
  before { sign_in users(:one) }

  describe "DELETE /destroy" do
    context "with islets without associations" do
      it do
        expect do
          delete bulk_islets_path(ids: [islets(:three).id, islets(:five).id])
        end.to change(Islet, :count).by(-2)
      end

      it do
        delete bulk_islets_path(ids: [islets(:three).id, islets(:five).id])
        expect(response).to redirect_to(islets_path)
      end
    end

    context "with a islets with associations" do
      it do
        expect do
          delete bulk_islets_path(ids: [islets(:one).id])
        end.not_to change(Islet, :count)
      end

      it do
        delete bulk_islets_path(ids: [islets(:one).id])
        expect(response).to redirect_to(islets_path)
      end
    end
  end
end
