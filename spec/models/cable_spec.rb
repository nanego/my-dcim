# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cable, type: :model do
  it_behaves_like "changelogable", attribute_name: :name, new_value: "New name"

  describe "associations" do
    it { is_expected.to have_many(:connections).dependent(:destroy) }
    it { is_expected.to have_many(:ports).through(:connections) }
  end
end
