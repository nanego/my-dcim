# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Connections" do
  let(:connection) { connections(:one) }

  before do
    sign_in users(:one)

    connection.save!
  end

  describe "GET #index" do
    before { get connections_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(connection.id.to_s) }
  end
end
