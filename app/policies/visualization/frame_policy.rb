# frozen_string_literal: true

module Visualization
  class FramePolicy < ::FramePolicy
    def print?
      manage?
    end

    def network?
      index?
    end

    def cables_export?
      manage?
    end
  end
end
