# frozen_string_literal: true

require "rails_helper"

RSpec.describe BaseExporter do
  describe "default attribute names" do
    it { expect(described_class::DEFAULT_ATTRIBUTE_NAMES).to eq(%w[id created_at updated_at]) }
  end
end
