# frozen_string_literal: true

module Visualization
  class NetworkCapacityPolicy < ApplicationPolicy
    def show?
      user.can_access_all_domains?
    end
  end
end
