# frozen_string_literal: true

module Visualization
  class BayPolicy < ::BayPolicy
    def print?
      manage?
    end

    def cables_export?
      manage?
    end
  end
end
