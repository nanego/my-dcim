# frozen_string_literal: true

class IsletPolicy < ApplicationPolicy
  def print?
    index?
  end
end
