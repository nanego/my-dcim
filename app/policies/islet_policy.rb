# frozen_string_literal: true

class IsletPolicy < ApplicationPolicy
  def print?
    user.reader? || user.writer?
  end
end
