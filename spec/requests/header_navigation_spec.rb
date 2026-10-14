# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Header navigation" do
  subject(:response) do
    get servers_path

    # NOTE: used to simplify usage and custom test done in final spec file.
    @response # rubocop:disable RSpec/InstanceVariable
  end

  context "with a writer" do
    include_context "with authenticated writer"

    it "links to both synchronization pages in the IT equipment dropdown" do
      expect(response.body).to include(%(class="dropdown-item" href="#{external_app_records_path}"))
        .and include(%(class="dropdown-item" href="#{netsight_sync_results_path}"))
    end
  end

  context "with a reader" do
    include_context "with authenticated reader"

    it "hides the synchronization links" do
      expect(response.body).not_to include(%(class="dropdown-item" href="#{external_app_records_path}"),
                                           %(class="dropdown-item" href="#{netsight_sync_results_path}"))
    end
  end
end
