# frozen_string_literal: true

class MovesProjectPolicy < ApplicationPolicy
  def index?
    manage?
  end

  def archive?
    manage?
  end
end
