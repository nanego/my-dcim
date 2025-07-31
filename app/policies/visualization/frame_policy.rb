# frozen_string_literal: true

module Visualization
  class FramePolicy < ApplicationPolicy
    def print?
      index?
    end
  end
end
