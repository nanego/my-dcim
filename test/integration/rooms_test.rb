# frozen_string_literal: true

require 'test_helper'

class RoomsTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @room = rooms(:one)
  end

  test 'user visits rooms' do
    visit room_url(@room)
    # TODO
  end

  test 'user exports a room to txt' do
    visit room_url(@room, format: :txt)
    # TODO
  end
end
