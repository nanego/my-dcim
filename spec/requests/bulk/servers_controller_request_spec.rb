# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bulk::ServersController do
  describe "DELETE #destroy" do
    subject(:response) do
      delete bulk_servers_path(ids:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:ids) { [] }

    include_context "with authenticated admin"

    context "with servers without associations" do
      let(:ids) { [servers(:two).id, servers(:four).id] }

      it { expect { response }.to have_authorized_scope(:active_record_relation).with(ServerPolicy) }
      it { expect { response }.to change(Server, :count).by(-2) }
      it { expect(response).to redirect_to(servers_path) }
    end

    context "with a server with associations" do
      let(:ids) { [servers(:one).id] }

      it { expect { response }.to have_authorized_scope(:active_record_relation).with(ServerPolicy) }
      it { expect { response }.not_to change(Server, :count) }
      it { expect(response).to redirect_to(servers_path) }
    end
  end

  describe "GET #cables_export" do
    subject(:response) do
      get cables_export_bulk_servers_path(ids:, format:)
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:format) { nil }
    let(:ids) { [servers(:two).id, servers(:four).id] }

    include_context "with authenticated admin"

    context "with pdf format" do
      let(:format) { :pdf }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:cables_export) }
      it { expect(response).to render_template("layouts/pdf") }
      it { expect(response.headers["Content-Type"]).to eq("application/pdf") }
    end

    context "without format" do
      it { expect { response }.to raise_error(ActionController::UnknownFormat) }
    end
  end
end
