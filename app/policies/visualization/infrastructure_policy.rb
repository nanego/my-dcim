# frozen_string_literal: true

module Visualization
  class InfrastructurePolicy < ApplicationPolicy
    def show?
      manage?
    end
  end
end
