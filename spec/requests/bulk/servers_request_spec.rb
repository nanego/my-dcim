# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bulk::ServersController do
  before { sign_in users(:admin) }

  describe "DELETE #destroy" do
    subject(:response) do
      delete bulk_servers_path(ids:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:ids) { [] }

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
end
