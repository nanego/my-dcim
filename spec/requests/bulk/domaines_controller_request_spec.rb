# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bulk::DomainesController do
  before { sign_in users(:admin) }

  describe "DELETE #destroy" do
    subject(:response) do
      delete bulk_domaines_path(ids:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:ids) { [] }

    context "with domains without associations" do
      let(:ids) { [domaines(:three).id, domaines(:stock).id] }

      it { expect { response }.to have_authorized_scope(:active_record_relation).with(DomainePolicy) }
      it { expect { response }.to change(Domaine, :count).by(-2) }
      it { expect(response).to redirect_to(domaines_path) }
    end

    context "with a domain with associations" do
      let(:ids) { [domaines(:switch).id] }

      it { expect { response }.to have_authorized_scope(:active_record_relation).with(DomainePolicy) }
      it { expect { response }.not_to change(Domaine, :count) }
      it { expect(response).to redirect_to(domaines_path) }
    end
  end
end
