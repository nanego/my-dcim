# frozen_string_literal: true

require "rails_helper"

RSpec.describe DataImportPolicy, type: :policy do
  it_behaves_like "with default index policy"

  it_behaves_like "act as manage policy", for: :ansible?
end
