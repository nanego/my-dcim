# frozen_string_literal: true

module Visualization
  class NetworkCapacityPolicy < ApplicationPolicy
    def show?
      user.all_domains?
    end
  end
end
