# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bulk::CablesController do
  before { sign_in users(:admin) }

  describe "DELETE #destroy" do
    subject(:response) do
      delete bulk_cables_path(ids:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:ids) { [] }

    context "with cables without associations" do
      let(:ids) { [cables(:one).id, cables(:two).id] }

      it { expect { response }.to have_authorized_scope(:active_record_relation).with(CablePolicy) }
      it { expect { response }.to change(Cable, :count).by(-2) }
      it { expect(response).to redirect_to(cables_path) }
    end
  end
end
