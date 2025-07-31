# frozen_string_literal: true

class ConnectionPolicy < ApplicationPolicy
  def update_destination_server?
    manage?
  end

  def draw?
    index?
  end
end
