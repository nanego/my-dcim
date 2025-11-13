# frozen_string_literal: true

module Visualization
  class NetworkCapacityPolicy < ApplicationPolicy
    def show?
      manage?
    end
  end
end
