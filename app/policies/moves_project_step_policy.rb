# frozen_string_literal: true

class MovesProjectStepPolicy < ApplicationPolicy
  def frame?
    index?
  end

  def print?
    index?
  end

  def execute?
    manage?
  end
end
