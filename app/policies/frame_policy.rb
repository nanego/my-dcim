# frozen_string_literal: true

class FramePolicy < ApplicationPolicy
  def sort?
    user.reader? || user.writer?
  end

  def network?
    user.reader?
  end
end
