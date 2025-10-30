# frozen_string_literal: true

module Visualization
  class BayPolicy < ApplicationPolicy
    relation_scope do |relation|
      return relation if user.admin?

      relation.where(frames: authorized_scope(Frame.all))
    end

    def print?
      index?
    end
  end
end
