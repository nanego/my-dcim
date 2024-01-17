# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Enclosure, type: :model do
  # it_behaves_like "changelogable", new_attributes: { display: "New value" }

  describe "associations" do
    it { is_expected.to belong_to(:modele) }
    it { is_expected.to have_many(:composants) }
  end
end
