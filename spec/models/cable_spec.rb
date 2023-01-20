# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cable, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:connections).dependent(:destroy) }
    it { is_expected.to have_many(:ports).through(:connections) }
  end
end
