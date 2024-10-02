# frozen_string_literal: true

class TypeComposant < ApplicationRecord
  has_changelog

  has_many :composants
end
