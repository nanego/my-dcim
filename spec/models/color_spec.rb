# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Color, type: :model do
  it_behaves_like "changelogable", attribute_name: :code, new_value: "FFAAFF"

  describe "associations" do
    it { is_expected.to be_valid }
  end
end
