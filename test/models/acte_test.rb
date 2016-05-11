require 'test_helper'

class ActeTest < ActiveSupport::TestCase
  def setup
    @acte = Acte.new(title: "Le titre")
  end

  def test_to_s_method
    assert_equal "Le titre", @acte.to_s
  end
end
