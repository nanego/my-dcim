# frozen_string_literal: true

module Visualization
  class BayPolicy < ApplicationPolicy
    def print?
      index?
    end
  end
end
