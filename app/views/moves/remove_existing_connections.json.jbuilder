# frozen_string_literal: true

json.array! @created_move_connections, partial: "moves/connections/connection", as: :move_connection
