# frozen_string_literal: true

module Visualization
  class BayPolicy < ::BayPolicy
    def print?
      manage?
    end
  end
end
