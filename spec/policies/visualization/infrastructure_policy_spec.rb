# frozen_string_literal: true

require "rails_helper"

RSpec.describe Visualization::InfrastructurePolicy, type: :policy do
  it_behaves_like "act as manage policy", for: :show?
end
