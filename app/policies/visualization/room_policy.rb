# frozen_string_literal: true

module Visualization
  class RoomPolicy < ApplicationPolicy
    relation_scope do |relation|
      return relation if user.admin?

      relation.where(islets: authorized_scope(Islet.all))
    end

    def print?
      index?
    end
  end
end
