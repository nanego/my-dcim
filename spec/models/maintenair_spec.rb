# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maintainer, type: :model do
  let(:maintainer) { Maintainer.create(name: "Dell") }

  describe "associations" do
    it { is_expected.to have_many(:maintenance_contracts) }
  end

  describe "#to_s" do
    it { expect(maintainer.to_s).to eq maintainer.name }
  end
end
