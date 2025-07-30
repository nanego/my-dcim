# frozen_string_literal: true

module Visualization
  class FramePolicy < ApplicationPolicy
    def print?
      user.reader?
    end
  end
end
