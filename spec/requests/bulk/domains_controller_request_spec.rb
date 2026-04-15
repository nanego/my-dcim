# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bulk::DomainsController do
  before { sign_in users(:admin) }

  describe "DELETE #destroy" do
    subject(:response) do
      delete bulk_domains_path(ids:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:ids) { [] }

    context "with domains without associations" do
      let(:ids) { [domains(:empty_domain).id, domains(:empty_domain_two).id] }

      it { expect { response }.to have_authorized_scope(:active_record_relation).with(DomainPolicy) }
      it { expect { response }.to change(Domain, :count).by(-2) }
      it { expect(response).to redirect_to(domains_path) }
    end

    context "with a domain with associations" do
      let(:ids) { [domains(:switch).id] }

      it { expect { response }.to have_authorized_scope(:active_record_relation).with(DomainPolicy) }
      it { expect { response }.not_to change(Domain, :count) }
      it { expect(response).to redirect_to(domains_path) }
    end
  end
end
