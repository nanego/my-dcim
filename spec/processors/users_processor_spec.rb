# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { User.all }
  let(:params) { {} }

  describe "when filtering" do
    let!(:user_active) do
      User.create!(name: "John Doe", email: "john@doe.co", password: "passwordpassword",
        password_confirmation: "passwordpassword")
    end
    let!(:user_suspended) do
      User.create!(name: "Jane Doe", email: "jane@doe.co", password: "passwordpassword",
        password_confirmation: "passwordpassword", suspended_at: Time.zone.now)
    end

    context "on suspended" do
      let(:params) { { filter: "suspended" } }

      it { is_expected.to include(user_suspended) }
      it { is_expected.not_to include(user_active) }
    end

    context "on default" do
      it { is_expected.not_to include(user_suspended) }
      it { is_expected.to include(user_active) }
    end
  end

  describe "when sorting" do
    pending "TODO"
  end
end
