# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  subject(:user) { described_class.new(email: "user@example.com") }

  it_behaves_like "changelogable", object: -> { described_class.new(email: "user@example.com") },
                                   new_attributes: { email: "admin@example.com" }

  describe "#to_s" do
    it { expect(user.to_s).to eq "user@example.com" }
  end

  describe "#set_default_role" do
    it { expect(user.set_default_role).to eq "user" }
  end

  describe "enumerize user role" do
    it { is_expected.to define_enum_for(:role).with_values([:user, :vip, :admin]) }
  end

  describe "#regenerate_authentication_token!" do
    before do
      user.update!(authentication_token: "auth_token")
      user.regenerate_authentication_token!
    end

    it { expect(user.authentication_token).not_to eq("auth_token") }
  end

  describe "#active_for_authentication?" do
    it { expect(user.active_for_authentication?).to be(true) }

    context "when suspended" do
      before { user.suspended_at = Time.zone.now }

      it { expect(user.active_for_authentication?).to be(false) }
    end
  end

  describe "#inactive_message" do
    context "when suspended" do
      before { user.suspended_at = Time.zone.now }

      it { expect(user.inactive_message).to eq(:suspended) }
    end
  end

  describe "#suspended?" do
    it { expect(user.suspended?).to be(false) }

    context "when suspended" do
      before { user.suspended_at = Time.zone.now }

      it { expect(user.suspended?).to be(true) }
    end
  end

  describe "#suspend!" do
    it do
      expect do
        user.suspend!
        user.reload
      end.to change(user, :suspended_at).from(nil)
    end
  end

  describe "#unsuspend!" do
    before { user.update!(suspended_at: Time.zone.now) }

    it do
      expect do
        user.unsuspend!
        user.reload
      end.to change(user, :suspended_at).to(nil)
    end
  end
end
