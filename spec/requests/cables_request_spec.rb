# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Cables" do
  let(:cable) { cables(:one) }

  before do
    sign_in users(:one)

    cable
  end

  describe "GET #index" do
    subject(:response) do
      get cables_path

      @response # rubocop:disable RSpec/InstanceVariable
    end

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(cable.id.to_s) }
  end

  describe "DELETE #destroy" do
    subject(:response) do
      delete cable_path(cable)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    context "with not found cable" do
      before { cable.id = 999_999_999 }

      it { expect { response }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "with existing cable" do
      it { expect(response).to have_http_status(:redirect) }

      it do
        expect { response }.to change(Cable, :count).by(-1)
      end
    end
  end
end
