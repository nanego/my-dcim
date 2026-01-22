# frozen_string_literal: true

json.extract! move, :id, :moveable, :frame, :position, :prev_frame, :created_at, :updated_at
json.url moves_project_step_move_path(move.step, move, format: :json)
