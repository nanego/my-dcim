class Move < ApplicationRecord
  belongs_to :moveable, polymorphic: true

  belongs_to :frame
  belongs_to :prev_frame, class_name: :frame, foreign_key: :prev_frame_id

  validates_presence_of :frame, :moveable

end
