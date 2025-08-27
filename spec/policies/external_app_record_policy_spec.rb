# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalAppRecordPolicy, type: :policy do
  it_behaves_like "with default index policy"

  it_behaves_like "act as index policy", for: :settings?
  it_behaves_like "act as manage policy", for: :sync_all_servers_with_glpi?
end
