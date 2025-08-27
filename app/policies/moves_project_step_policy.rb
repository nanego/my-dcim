# frozen_string_literal: true

class MovesProjectStepPolicy < ApplicationPolicy
  pre_check :deny_readers

  def frame?
    manage?
  end

  def print?
    manage?
  end

  def execute?
    manage?
  end
end
