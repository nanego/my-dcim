# frozen_string_literal: true

class MovesProjectPolicy < ApplicationPolicy
  pre_check :deny_readers

  def archive?
    manage?
  end
end
