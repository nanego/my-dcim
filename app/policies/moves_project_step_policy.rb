# frozen_string_literal: true

class MovesProjectStepPolicy < ApplicationPolicy
  pre_check :deny_readers

  def execute?
    manage?
  end
end
