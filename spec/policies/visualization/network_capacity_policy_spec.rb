# frozen_string_literal: true

require "rails_helper"

RSpec.describe Visualization::NetworkCapacityPolicy, type: :policy do
  it_behaves_like "with default index policy"
end
