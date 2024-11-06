# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact do
  subject(:contact) { described_class.new(first_name: "John", last_name: "Doe") }

  it_behaves_like "changelogable", object: -> { described_class.new(first_name: "John", last_name: "Doe") },
                                   new_attributes: { first_name: "Jane", last_name: "Does" }

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }

    it { is_expected.to allow_value("john@doe.fr").for(:email) }
    it { is_expected.not_to allow_value("this-is-not-a-valid-email").for(:email) }
  end
end
