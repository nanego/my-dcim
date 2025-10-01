# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  subject(:user) { described_class.new(email: "user@example.com") }

  it_behaves_like "changelogable", object: -> { described_class.new(email: "user@example.com") },
                                   new_attributes: { email: "admin@example.com" }

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_inclusion_of(:locale).in_array(I18n.available_locales.map(&:to_s)) }
    it { is_expected.to allow_value(nil).for(:locale) }

    it { is_expected.to validate_inclusion_of(:theme).in_array(%w[auto dark light]) }
    it { is_expected.to allow_value(nil).for(:theme) }

    it { is_expected.to validate_inclusion_of(:items_per_page).in_array([25, 50, 100, 150, 200]) }
    it { is_expected.to allow_value(nil).for(:items_per_page) }

    it { is_expected.to validate_inclusion_of(:visualization_bay_default_background_color).in_array(%w[modele gestion cluster]) }
    it { is_expected.to allow_value(nil).for(:visualization_bay_default_background_color) }

    it { is_expected.to validate_inclusion_of(:visualization_bay_default_orientation).in_array(%w[front back]) }
    it { is_expected.to allow_value(nil).for(:visualization_bay_default_orientation) }
  end

  describe "email is normalized" do
    context "with an upcase email" do
      before { user.email = "EMAIL@EMAIL.COM" }

      it { expect(user.email).to eq("email@email.com") }
    end

    context "with an empty email" do
      before { user.email = "" }

      it { expect(user.email).to be_nil }
    end

    context "with a nil email" do
      before { user.email = nil }

      it { expect(user.email).to be_nil }
    end
  end

  describe "#to_s" do
    it { expect(user.to_s).to eq "user@example.com" }
  end

  describe "enumerize user role" do
    it { is_expected.to define_enum_for(:role).with_values(%i[reader writer]) }
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

  describe "#writer?" do
    it { expect(user.writer?).to be(false) }

    context "when is in a permission_scope with role writer" do
      subject(:user) do
        described_class.new(email: "user@example.com", permission_scopes: [permission_scopes(:writer)])
      end

      it { expect(user.writer?).to be(true) }
    end
  end

  describe "#permitted_domains" do
    it { expect(user.permitted_domains).to be_empty }

    context "with permission_scopes" do
      subject(:user) { users(:writer) }

      it { expect(user.permitted_domains).to match_array(Domaine.all) }
    end
  end
end
