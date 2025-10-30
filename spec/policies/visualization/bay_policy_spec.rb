# frozen_string_literal: true

require "rails_helper"

RSpec.describe Visualization::BayPolicy, type: :policy do
  it_behaves_like "with default index policy"

  it_behaves_like "act as index policy", for: :print?
end
