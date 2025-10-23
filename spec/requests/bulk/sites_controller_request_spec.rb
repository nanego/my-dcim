# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bulk::SitesController do
  before { sign_in users(:admin) }

  describe "DELETE #destroy" do
    subject(:response) do
      delete bulk_sites_path(ids:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:ids) { [] }

    context "with sites without associations" do
      let(:ids) { [sites(:four).id, sites(:five).id] }

      it { expect { response }.to have_authorized_scope(:active_record_relation).with(SitePolicy) }
      it { expect { response }.to change(Site, :count).by(-2) }
      it { expect(response).to redirect_to(sites_path) }
    end

    context "with a site with associations" do
      let(:ids) { [sites(:one).id] }

      it { expect { response }.to have_authorized_scope(:active_record_relation).with(SitePolicy) }
      it { expect { response }.not_to change(Site, :count) }
      it { expect(response).to redirect_to(sites_path) }
    end
  end
end
