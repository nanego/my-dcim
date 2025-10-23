# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bulk::IsletsController do
  before { sign_in users(:admin) }

  describe "DELETE #destroy" do
    subject(:response) do
      delete bulk_islets_path(ids:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:ids) { [] }

    context "with islets without associations" do
      let(:ids) { [islets(:three).id, islets(:five).id] }

      it { expect { response }.to have_authorized_scope(:active_record_relation).with(IsletPolicy) }
      it { expect { response }.to change(Islet, :count).by(-2) }
      it { expect(response).to redirect_to(islets_path) }
    end

    context "with a islet with associations" do
      let(:ids) { [islets(:one).id] }

      it { expect { response }.to have_authorized_scope(:active_record_relation).with(IsletPolicy) }
      it { expect { response }.not_to change(Islet, :count) }
      it { expect(response).to redirect_to(islets_path) }
    end
  end
end
