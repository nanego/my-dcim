# frozen_string_literal: true

module Visualization
  class IsletPolicy < ::IsletPolicy
    def print?
      manage?
    end
  end
end
