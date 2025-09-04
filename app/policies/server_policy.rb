# frozen_string_literal: true

class ServerPolicy < ApplicationPolicy
  def duplicate?
    manage?
  end

  def destroy_connections?
    manage?
  end

  def sort?
    manage?
  end

  def import?
    manage?
  end

  def import_csv?
    manage?
  end

  def export?
    index?
  end
end
