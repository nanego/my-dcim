# frozen_string_literal: true

class MovePolicy < ApplicationPolicy
  def execute?
    manage?
  end

  def load_server?
    index?
  end

  def load_frame?
    index?
  end

  def load_connection?
    index?
  end

  def update_connection?
    manage?
  end
end
