require 'test_helper'

class MoveTest < ActiveSupport::TestCase

  def setup
    @move = moves(:one)
  end

  test 'valid move' do
    assert @move.valid?
  end

  test 'invalid without frame' do
    @move.frame = nil
    refute @move.valid?, 'saved move without a frame'
    assert_not_nil @move.errors[:frame], 'no validation error for frame present'
  end

  test 'invalid without moveable object associated' do
    @move.moveable = nil
    refute @move.valid?
    assert_not_nil @move.errors[:moveable]
  end

  test 'clear current connections' do
    # Before
    @moved_connections = MovedConnection.per_servers([@move.moveable])
    assert_empty @moved_connections.select{|c|c.port_from_id == 2}

    # Re-init moved connections
    @move.clear_connections

    # After
    @moved_connections = MovedConnection.per_servers([@move.moveable])
    @move.moveable.ports.each do |port|
      moved_connection = @moved_connections.select{|c|c.port_from_id == port.id}.first
      assert_not_nil moved_connection
      assert moved_connection.cablename==''
      assert moved_connection.color==''
    end
  end

  test 'execution of a movement' do
    assert @move.moveable.position != @move.position
    @move.execute_movement
    assert @move.moveable.reload.frame == @move.frame
    assert @move.moveable.reload.position == @move.position
    assert_empty Move.where(id: @move.id)
  end
  
end
