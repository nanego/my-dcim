# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it_behaves_like "changelogable", object: -> { described_class.new(email: "user@example.com") },
                                   new_attributes: { email: "admin@example.com" }

  let(:user) { User.create(email: "user@example.com") }

  describe "#to_s" do
    it { expect(user.to_s).to eq "user@example.com" }
  end

  describe "#set_default_role" do
    it { expect(user.set_default_role).to eq "user" }
  end

  describe "enumerize user role" do
    it { should define_enum_for(:role).with_values([:user, :vip, :admin]) }
  end
end
