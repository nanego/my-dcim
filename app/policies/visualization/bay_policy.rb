# frozen_string_literal: true

module Visualization
  class BayPolicy < ApplicationPolicy
    def print?
      user.reader?
    end
  end
end
