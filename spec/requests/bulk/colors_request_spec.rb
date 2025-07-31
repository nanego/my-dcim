# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/colors" do
  before { sign_in users(:admin) }

  describe "DELETE /destroy" do
    context "with colors without associations" do
      it do
        expect do
          delete bulk_colors_path(ids: [colors(:one).id, colors(:two).id])
        end.to change(Color, :count).by(-2)
      end

      it do
        delete bulk_colors_path(ids: [colors(:one).id, colors(:two).id])
        expect(response).to redirect_to(colors_path)
      end
    end
  end
end
