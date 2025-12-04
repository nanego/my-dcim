# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchResult do
  describe "associations" do
    it { is_expected.to belong_to(:searchable) }
  end

  describe ".search" do
    pending
  end
end
