# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cable do
  it_behaves_like "changelogable", new_attributes: { name: "New name" }

  describe "associations" do
    it { is_expected.to have_many(:connections).dependent(:destroy) }
    it { is_expected.to have_many(:ports).through(:connections) }
    it { is_expected.to have_many(:servers).through(:connections) }
    it { is_expected.to have_many(:cards).through(:connections) }
    it { is_expected.to have_many(:card_types).through(:cards) }
    it { is_expected.to have_many(:port_types).through(:card_types) }
  end
end
