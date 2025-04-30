# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/manufacturers" do
  before { sign_in users(:one) }

  describe "DELETE /destroy" do
    context "with manufacturers without associations" do
      it do
        expect do
          delete bulk_manufacturers_path(ids: [manufacturers(:three).id, manufacturers(:four).id])
        end.to change(Manufacturer, :count).by(-2)
      end

      it do
        delete bulk_manufacturers_path(ids: [manufacturers(:three).id, manufacturers(:four).id])
        expect(response).to redirect_to(manufacturers_path)
      end
    end

    context "with a manufacturer with associations" do
      it do
        expect do
          delete bulk_manufacturers_path(ids: [manufacturers(:fortinet).id])
        end.not_to change(Manufacturer, :count)
      end

      it do
        delete bulk_manufacturers_path(ids: [manufacturers(:fortinet).id])
        expect(response).to redirect_to(manufacturers_path)
      end
    end
  end
end
