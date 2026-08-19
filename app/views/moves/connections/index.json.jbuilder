# frozen_string_literal: true

json.array! @move_connections, partial: "moves/connections/connection", as: :move_connection
