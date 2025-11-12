# frozen_string_literal: true

module Visualization
  class RoomPolicy < ::RoomPolicy
    def print?
      manage?
    end
  end
end
