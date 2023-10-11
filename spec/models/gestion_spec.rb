# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gestion, type: :model do
  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  let(:gestion) { Gestion.create(name: "DIS/GIL") }

  describe "associations" do
    it { is_expected.to have_many(:servers) }
  end

  describe "#to_s" do
    it { expect(gestion.to_s).to eq gestion.name }
  end
end
