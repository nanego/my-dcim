# frozen_string_literal: true

class ServersGridPolicy < ApplicationPolicy
  def index?
    return true if user.writer?

    false
  end
end
