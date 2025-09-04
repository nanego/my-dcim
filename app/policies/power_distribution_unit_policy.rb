# frozen_string_literal: true

class PowerDistributionUnitPolicy < ApplicationPolicy
  def duplicate?
    manage?
  end

  def destroy_connections?
    manage?
  end
end
