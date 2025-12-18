# frozen_string_literal: true

module Visualization
  class FramePolicy < ::FramePolicy
    def print?
      manage?
    end

    def network?
      index?
    end
  end
end
