# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Color, type: :model do
  it_behaves_like "changelogable", new_attributes: { code: "123456" }

  describe "associations" do
    it { is_expected.to be_valid }
  end
end
