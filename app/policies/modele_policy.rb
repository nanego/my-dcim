# frozen_string_literal: true

class ModelePolicy < ApplicationPolicy
  def duplicate?
    manage?
  end
end
