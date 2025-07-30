# frozen_string_literal: true

class FramePolicy < ApplicationPolicy
  def sort?
    user.writer?
  end

  def network?
    user.reader? || user.writer?
  end
end
