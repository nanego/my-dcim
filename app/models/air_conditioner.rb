class AirConditioner < ApplicationRecord
  has_changelog

  belongs_to :bay
  belongs_to :air_conditioner_model

  has_one :room, through: :bay
  has_one :islet, through: :bay

  enum status: { on: 'on', off: 'off' }
  enum position: { left: 'left', right: 'right' }

  validates :status, inclusion: { in: %w(on off),
                                  message: "%{value} is not a valid status" }

  validates :position, inclusion: { in: %w(left right),
                                  message: "%{value} is not a valid position" }

  def to_s
    name
  end

end
