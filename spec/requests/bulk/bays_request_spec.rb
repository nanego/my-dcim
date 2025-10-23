# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bulk::BaysController do
  before { sign_in users(:admin) }

  describe "DELETE #destroy" do
    subject(:response) do
      delete bulk_bays_path(ids:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:ids) { [] }

    context "with bays without associations" do
      let(:ids) { [bays(:three).id, bays(:five).id] }

      it { expect { response }.to have_authorized_scope(:active_record_relation).with(BayPolicy) }
      it { expect { response }.to change(Bay, :count).by(-2) }
      it { expect(response).to redirect_to(bays_path) }
    end

    context "with a bay with associations" do
      let(:ids) { [bays(:one).id] }

      it { expect { response }.to have_authorized_scope(:active_record_relation).with(BayPolicy) }
      it { expect { response }.not_to change(Bay, :count) }
      it { expect(response).to redirect_to(bays_path) }
    end
  end
end
