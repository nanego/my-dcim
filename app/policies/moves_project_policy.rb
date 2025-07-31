# frozen_string_literal: true

class MovesProjectPolicy < ApplicationPolicy
  def archive?
    manage?
  end
end
