# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/managers" do
  before { sign_in users(:admin) }

  describe "DELETE /destroy" do
    context "with managers without associations" do
      it do
        expect do
          delete bulk_managers_path(ids: [managers(:three).id, managers(:two).id])
        end.to change(Manager, :count).by(-2)
      end

      it do
        delete bulk_managers_path(ids: [managers(:three).id, managers(:two).id])
        expect(response).to redirect_to(managers_path)
      end
    end

    context "with a manager type with associations" do
      it do
        expect do
          delete bulk_managers_path(ids: [managers(:one).id])
        end.not_to change(Manager, :count)
      end

      it do
        delete bulk_managers_path(ids: [managers(:one).id])
        expect(response).to redirect_to(managers_path)
      end
    end
  end
end
