# frozen_string_literal: true

class SitePolicy < ApplicationPolicy
  def sort?
    user.writer?
  end

  def import?
    user.writer?
  end

  def duplicate?
    user.writer?
  end
end
