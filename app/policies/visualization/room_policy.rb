# frozen_string_literal: true

module Visualization
  class RoomPolicy < ApplicationPolicy
    def print?
      index?
    end
  end
end
