# frozen_string_literal: true

require "test_helper"

class MoveTest < ActiveSupport::TestCase
  def setup
    @move = moves(:one)
  end

  test "invalid without frame" do
    @move.frame = nil
    assert_not @move.valid?, "saved move without a frame"
    assert_not_nil @move.errors[:frame], "no validation error for frame present"
  end

  test "invalid without moveable object associated" do
    @move.moveable = nil
    assert_not @move.valid?
    assert_not_nil @move.errors[:moveable]
  end

  test "clear current connections" do
    # Before
    @move_connections = Move::Connection.per_servers([@move.moveable])
    assert_empty(@move_connections.select { |c| c.port_from_id == 2 })

    # Re-init moved connections
    @move.remove_existing_connections_on_execution = true
    @move.clear_connections

    # After
    @move_connections = Move::Connection.per_servers([@move.moveable])
    @move.moveable.ports.each do |port|
      move_connection = @move_connections.find { |c| c.port_from_id == port.id }
      assert_not_nil move_connection
      assert move_connection.cablename == ""
      assert move_connection.color == ""
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
    @move_connection = @move.move_connections.first
    @port_from = @move_connection.port_from
    assert @port_from.cable_name != @move_connection.cablename
    assert_nil @move.executed_at

    @move.execute!
    @move.reload
    @move_connection.reload

    assert @move.moveable.reload.frame == @move.frame
    assert @port_from.reload.cable_name == @move_connection.cablename

    assert @move.executed_at
    assert Move.where(id: @move.id)
    assert @move_connection.executed_at
    assert Move::Connection.find_by(id: @move_connection.id)
  end
end
