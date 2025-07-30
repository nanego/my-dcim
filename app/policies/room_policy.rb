# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  def overview?
    user.reader?
  end
end
