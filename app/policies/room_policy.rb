# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  def overview?
    index?
  end
end
