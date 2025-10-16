# frozen_string_literal: true

class PowerDistributionUnitPolicy < ApplicationPolicy
  def duplicate?
    manage?
  end
end
