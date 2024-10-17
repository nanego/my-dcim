# frozen_string_literal: true

require 'test_helper'

class RoomsTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @room = rooms(:one)
  end

  # TODO
  # test 'user visits rooms' do
  #   visit room_url(@room)
  # end

  # TODO
  # test 'user exports a room to txt' do
  #   visit visualization_room_url(@room, format: :txt)
  # end
end
