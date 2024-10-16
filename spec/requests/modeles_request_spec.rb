# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/modeles" do
  let(:modele) { modeles(:one) }

  before do
    sign_in users(:one)

    modele.save
  end

  describe "GET /duplicate" do
    before { get duplicate_modele_path(modele) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:duplicate) }
  end
end
