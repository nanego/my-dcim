# frozen_string_literal: true

class ServerPolicy < ApplicationPolicy
  def sort?
    user.writer?
  end

  def import?
    user.writer?
  end

  def import_csv?
    user.writer?
  end

  def duplicate?
    user.writer?
  end

  def export?
    user.reader? || user.writer?
  end
end
