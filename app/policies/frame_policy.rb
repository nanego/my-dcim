# frozen_string_literal: true

class FramePolicy < ApplicationPolicy
  def sort?
    manage?
  end

  def network?
    index?
  end
end
