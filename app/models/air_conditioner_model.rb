class AirConditionerModel < ApplicationRecord

  has_changelog

  belongs_to :manufacturer
  has_many :air_conditioners

  def to_s
    name
  end

end
