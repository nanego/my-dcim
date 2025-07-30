# frozen_string_literal: true

class PowerDistributionUnitPolicy < ApplicationPolicy
  def duplicate?
    user.writer?
  end
end
