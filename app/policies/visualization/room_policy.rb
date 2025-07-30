# frozen_string_literal: true

module Visualization
  class RoomPolicy < ApplicationPolicy
    def print?
      user.reader?
    end
  end
end
