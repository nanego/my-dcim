# frozen_string_literal: true

require "rails_helper"

RSpec.describe ColorsHelper do
  describe "color_representation_of" do
    it { expect(helper.color_representation_of("sample")).to eq("#c4f5ff") }
    it { expect(helper.color_representation_of(nil)).to eq("#6ff5d1") }
  end

  describe "lighten_color" do
    it { expect(helper.lighten_color("#123456")).to eq("#abcdef") }
  end
end
