# frozen_string_literal: true

require "rails_helper"

RSpec.describe Connection do
  # it_behaves_like "changelogable", new_attributes: {  }

  describe "associations" do
    it { is_expected.to belong_to(:cable) }
    it { is_expected.to belong_to(:port) }
  end

  describe "#paired_connection" do
    pending
  end
end
