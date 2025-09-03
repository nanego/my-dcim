# frozen_string_literal: true

require File.expand_path("../test_helper", __dir__)

class CardTest < ActiveSupport::TestCase
  test "stringify card" do
    assert_equal cards(:one).to_s, "Carte ServerName1 / Card1 / compo1"
  end
end
