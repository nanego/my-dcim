# frozen_string_literal: true

class DataImportPolicy < ApplicationPolicy
  def ansible?
    manage?
  end
end
