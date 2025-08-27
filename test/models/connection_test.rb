# frozen_string_literal: true

require "test_helper"

class ConnectionTest < ActiveSupport::TestCase
  setup do
    @connection1 = connections(:one)
    @connection2 = connections(:two)
  end

  test "paired_connection method" do
    assert_equal @connection1.paired_connection, @connection2
  end
end
