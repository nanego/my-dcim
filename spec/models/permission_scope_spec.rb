# frozen_string_literal: true

require "rails_helper"

RSpec.describe PermissionScope do
  subject(:permission_scope) { described_class.new(name: "A", all_domains: true) }

  it_behaves_like "changelogable", object: -> { described_class.new(name: "A", domaines: [domaines(:switch)]) },
                                   new_attributes: { name: "B", all_domains: true }

  describe "associations" do
    it { is_expected.to have_many(:permission_scope_domains) }
    it { is_expected.to have_many(:domaines).through(:permission_scope_domains) }
    it { is_expected.to have_many(:permission_scope_users) }
    it { is_expected.to have_many(:users).through(:permission_scope_users) }
  end

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }

    describe "validate domains" do
      context "when all_domains false and domaines empty" do
        subject(:permission_scope) { described_class.new(name: "A", all_domains: false) }

        it { is_expected.not_to be_valid }
      end

      context "when all_domains true and domaines empty" do
        subject(:permission_scope) do
          described_class.new(name: "A", all_domains: true, domaines: [])
        end

        it { is_expected.to be_valid }
      end

      context "when all_domains false and domaines not empty" do
        subject(:permission_scope) do
          described_class.new(name: "A", all_domains: false, domaines: [domaines(:switch)])
        end

        it { is_expected.to be_valid }
      end
    end
  end

  describe "enumerize user role" do
    it { is_expected.to define_enum_for(:role).with_values(%i[reader writer]) }
  end

  describe "#to_s" do
    it { expect(permission_scope.name).to eq("A") }
  end
end
