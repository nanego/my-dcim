# frozen_string_literal: true

require File.expand_path("../test_helper", __dir__)

class RoomTest < ActiveSupport::TestCase
  setup do
    @room = rooms(:one)
  end

  test "to_s method" do
    assert_equal @room.to_s, "S1"
  end

  test "name_with_site method" do
    assert_equal @room.name_with_site, "Site 1 - S1"
  end
end
