require File.expand_path("../../test_helper", __FILE__)

class FrameTest < ActiveSupport::TestCase

  test "relation has_many pdus" do
    assert_includes frames(:one).pdus, servers(:pdu)
  end

  test "name_with_room_and_islet" do
    assert_equal frames(:one).name_with_room_and_islet, "Salle S1 Ilot Islet1 Baie MyString"
  end

end
