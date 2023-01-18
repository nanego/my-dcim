class Site < ActiveRecord::Base

  geocoded_by :address
  after_validation :geocode

  has_many :rooms, dependent: :restrict_with_error

  scope :sorted, -> { order(:position) }

  def to_s
    name
  end

  def address
    [street, city, country].compact.join(', ')
  end

end
