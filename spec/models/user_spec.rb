# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { User.new(email: "user@example.com") }

  describe "#to_s" do
    it { expect(user.to_s).to eq "user@example.com" }
  end

  describe "#set_default_role" do
    it { expect(user.set_default_role).to eq "user" }
  end

  describe "enumerize user role" do
    it { should define_enum_for(:role).with_values([:user, :vip, :admin]) }
  end

  describe "#regenerate_authentication_token!" do
    before do
      user.authentication_token = "auth_token"
      user.regenerate_authentication_token!
    end

    it { expect(user.authentication_token).not_to eq("auth_token") }
  end
end
