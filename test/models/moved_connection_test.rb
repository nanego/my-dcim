require 'test_helper'

class MovedConnectionTest < ActiveSupport::TestCase
  def setup
    @connection = moved_connections(:one)
  end

  test 'valid move' do
    assert @connection.valid?
  end

  test 'invalid without port_from_id' do
    @connection.port_from_id = nil
    refute @connection.valid?, 'saved move without a port_from_id'
    assert_not_nil @connection.errors[:port_from_id], 'no validation error for port_from_id present'
  end

  test 'cablecolor should return the color attribute' do
    assert @connection.color == @connection.cable_color
  end

  test 'execution of a movement' do
    port_from = @connection.port_from
    refute port_from.cablename == @connection.cablename

    @connection.execute_movement

    port_from.reload
    assert port_from.cable_name == @connection.cablename
    assert_empty MovedConnection.where(id: @connection.id)
  end

end
