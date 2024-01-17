# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maintainer, type: :model do
  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  subject(:maintainer) { Maintainer.new(name: "Dell") }

  describe "associations" do
    it { is_expected.to have_many(:maintenance_contracts) }
  end

  describe "#to_s" do
    it { expect(maintainer.to_s).to eq maintainer.name }
  end
end
