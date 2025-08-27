# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalAppRequestPolicy, type: :policy do
  it_behaves_like "with default manage policy"

  it_behaves_like "act as manage policy", for: :index?
end
