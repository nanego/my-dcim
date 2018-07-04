require File.expand_path("../../test_helper", __FILE__)

class PortTest < ActiveSupport::TestCase
  test "cable_color" do
    assert_equal ports(:one).cable_color, "N"
  end

  test "cable_name" do
    assert_equal ports(:one).cable_name, "cableXYZ"
  end
end
