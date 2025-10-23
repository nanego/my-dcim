# frozen_string_literal: true

require "rails_helper"

RSpec.describe DomaineDecorator, type: :decorator do
  let(:user) { users(:admin) }

  describe ".options_for_select" do
    it do
      expect(described_class.options_for_select(user))
        .to contain_exactly(["Stock", 2], ["Switch", 1], ["Three", 3])
    end
  end
end
