# frozen_string_literal: true

require "test_helper"

class MoveTest < ActiveSupport::TestCase
  def setup
    @move = moves(:one)
  end

  test "invalid without frame" do
    @move.frame = nil
    refute @move.valid?, "saved move without a frame"
    assert_not_nil @move.errors[:frame], "no validation error for frame present"
  end

  test "invalid without moveable object associated" do
    @move.moveable = nil
    refute @move.valid?
    assert_not_nil @move.errors[:moveable]
  end

  test "clear current connections" do
    # Before
    @moved_connections = MovedConnection.per_servers([@move.moveable])
    assert_empty(@moved_connections.select { |c| c.port_from_id == 2 })

    # Re-init moved connections
    @move.clear_connections

    # After
    @moved_connections = MovedConnection.per_servers([@move.moveable])
    @move.moveable.ports.each do |port|
      moved_connection = @moved_connections.find { |c| c.port_from_id == port.id }
      assert_not_nil moved_connection
      assert moved_connection.cablename == ""
      assert moved_connection.color == ""
    end
  end

  test "execution of a movement" do
    assert @move.moveable.position != @move.position
    assert_nil @move.executed_at
    @move.execute!
    assert @move.moveable.reload.frame == @move.frame
    assert @move.moveable.reload.position == @move.position
    assert @move.executed_at
    assert Move.where(id: @move.id)
  end

  test "execution of a movement with connections" do
    @moved_connection = MovedConnection.per_servers([@move.moveable]).first
    @port_from = @moved_connection.port_from
    assert @port_from.cable_name != @moved_connection.cablename
    assert_nil @move.executed_at

    @move.execute!

    assert @move.moveable.reload.frame == @move.frame
    assert @port_from.reload.cable_name == @moved_connection.cablename

    assert @move.executed_at
    assert Move.where(id: @move.id)
    assert_empty MovedConnection.where(id: @moved_connection.id)
  end
end
