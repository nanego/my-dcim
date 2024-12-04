# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Connections" do
  let(:connection) { connections(:one) }
  let(:params) { {} }

  describe "GET #index" do
    subject(:response) do
      get connections_path(params)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(connection.id.to_s) }

    it { expect { response }.to have_rubanok_processed(Connection.all).with(ConnectionsProcessor) }

    context "when searching on server" do
      let(:params) { { server_ids: servers(:one).id } }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:index) }
      it { expect(response.body).to include(connections(:one).cable.name) }
      it { expect(response.body).not_to include(connections(:five).cable.name) }

      it { expect { response }.to have_rubanok_processed(Connection.all).with(ConnectionsProcessor) }
    end
  end
end
