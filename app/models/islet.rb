class Islet < ActiveRecord::Base

  belongs_to :room
  has_many :bays

  default_scope { order(:name) }

  def to_s
    name
  end

end
