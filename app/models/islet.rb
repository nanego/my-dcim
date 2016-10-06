class Islet < ActiveRecord::Base

  belongs_to :room
  has_many :bays
  has_many :frames, through: :bays
  has_many :servers, through: :frames

  scope :sorted, -> { order( :name ) }
  scope :not_empty, -> { joins(:servers) }
  scope :has_name, -> { where.not(name: nil) }

  def to_s
    name
  end

end
