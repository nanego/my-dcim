# frozen_string_literal: true

class MovePolicy < ApplicationPolicy
  pre_check :deny_readers

  def execute?
    manage?
  end

  def load_server?
    manage?
  end

  def load_frame?
    manage?
  end

  def load_connection?
    manage?
  end

  def update_connection?
    manage?
  end
end
