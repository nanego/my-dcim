# frozen_string_literal: true

require "rails_helper"

RSpec.describe ManufacturerDecorator, type: :decorator do
  describe ".options_for_select" do
    it do
      expect(described_class.options_for_select)
        .to contain_exactly(["Fourth", 4], ["Third", 3], ["fortinet", 1], ["juniper", 2])
    end
  end
end
