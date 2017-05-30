require File.expand_path("../../test_helper", __FILE__)

class ActeTest < ActiveSupport::TestCase
  def setup
    @acte = Acte.new(name: "Le titre")
  end

  def test_to_s_method
    assert_equal "Le titre", @acte.to_s
  end
end
