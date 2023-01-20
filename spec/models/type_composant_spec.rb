# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TypeComposant, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:composants) }
  end
end
