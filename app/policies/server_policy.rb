# frozen_string_literal: true

class ServerPolicy < ApplicationPolicy
  def sort?
    manage?
  end

  def import?
    manage?
  end

  def import_csv?
    manage?
  end

  def duplicate?
    manage?
  end

  def export?
    index?
  end
end
