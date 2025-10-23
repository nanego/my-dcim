# frozen_string_literal: true

require "rails_helper"

RSpec.describe SiteDecorator, type: :decorator do
  let(:user) { users(:admin) }

  describe ".options_for_select" do
    it do
      expect(described_class.options_for_select(user))
        .to contain_exactly(["Site 1", 1], ["Site 2", 2], ["Site 3", 3], ["Site 4", 4], ["Site 5", 5])
    end
  end
end
