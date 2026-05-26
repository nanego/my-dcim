# frozen_string_literal: true

class PowerDistributionUnitTypePolicy < ApplicationPolicy
  def duplicate?
    manage?
  end
end
