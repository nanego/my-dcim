require File.expand_path("../../test_helper", __FILE__)

class FrameTest < ActiveSupport::TestCase

  test "relation has_many pdus" do
    assert_includes frames(:one).pdus, servers(:pdu)
  end

end
