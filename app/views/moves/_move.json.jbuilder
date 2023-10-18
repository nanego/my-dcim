# frozen_string_literal: true

json.extract! move, :id, :moveable, :frame, :position, :prev_frame, :created_at, :updated_at
json.url move_url(move, format: :json)
