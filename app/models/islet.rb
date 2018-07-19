class Islet < ActiveRecord::Base

  belongs_to :room
  has_many :bays
  has_many :frames, through: :bays
  has_many :servers, through: :frames
  has_many :materials, through: :frames

  scope :sorted, -> { order( :position, :name ) }
  scope :not_empty, -> { joins(:materials) }
  scope :has_name, -> { where.not(name: nil) }

  def to_s
    name.to_s
  end

  def name_with_room
    "#{room} #{name.blank? ? "" : 'Ilot ' + name}"
  end

end
