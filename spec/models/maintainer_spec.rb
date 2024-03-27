# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maintainer do
  subject(:maintainer) { described_class.new(name: "Dell") }

  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  describe "associations" do
    it { is_expected.to have_many(:maintenance_contracts) }
  end

  describe "#to_s" do
    it { expect(maintainer.to_s).to eq maintainer.name }
  end
end
