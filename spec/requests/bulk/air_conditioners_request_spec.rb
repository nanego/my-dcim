# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/air_conditioners" do
  before { sign_in users(:one) }

  describe "DELETE /destroy" do
    context "with an air conditioner without association" do
      it do
        expect do
          delete bulk_air_conditioners_path(ids: [air_conditioners(:one).id, air_conditioners(:two).id])
        end.to change(AirConditioner, :count).by(-2)
      end

      it do
        delete bulk_air_conditioners_path(ids: [air_conditioners(:one).id, air_conditioners(:two).id])
        expect(response).to redirect_to(air_conditioners_path)
      end
    end
  end
end
