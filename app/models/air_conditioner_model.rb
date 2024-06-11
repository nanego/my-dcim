# frozen_string_literal: true

class AirConditionerModel < ApplicationRecord
  has_changelog

  belongs_to :manufacturer
  has_many :air_conditioners, dependent: :restrict_with_error

  def to_s
    name
  end
end
