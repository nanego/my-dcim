# frozen_string_literal: true

class MovesProjectStepPolicy < ApplicationPolicy
  def index?
    manage?
  end

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
