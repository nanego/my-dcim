class Bay < ActiveRecord::Base

  belongs_to :bay_type
  belongs_to :islet
  has_one :room, through: :islet
  has_many :frames
  has_many :materials, through: :frames

  acts_as_list scope: [:lane, :islet_id]

  scope :sorted, -> { order( :lane, :position ) }

  def to_s
    frames.sorted.map(&:name).join('/')
  end

  def detailed_name
    "#{room} #{islet.blank? ? '' : "Ilot #{islet.name}"}#{lane.blank? ? '' : " Ligne #{lane}"}#{position.blank? ? '':" Position #{position}"}#{frames.any? ? " (#{list_frames})" : ''}"
  end

  def list_frames
    frames.map(&:name).join(' / ')
  end

end
