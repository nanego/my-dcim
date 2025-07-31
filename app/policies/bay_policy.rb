# frozen_string_literal: true

class BayPolicy < ApplicationPolicy
  def print?
    index?
  end
end
