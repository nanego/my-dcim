# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  def overview?
    user.reader? || user.writer?
  end
end
