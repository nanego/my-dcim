# frozen_string_literal: true

class MovesProject < ApplicationRecord
  has_changelog

  has_many :steps, -> { order(:position) }, class_name: "MovesProjectStep", dependent: :restrict_with_error,
                                            inverse_of: :moves_project
  has_many :moves, through: :steps

  belongs_to :created_by, optional: true, class_name: "User"

  validates :name, presence: true

  scope :unarchived, -> { where(archived_at: nil) }

  accepts_nested_attributes_for :steps, allow_destroy: true, reject_if: :all_blank

  def to_s
    name
  end

  def archive!
    update!(archived_at: DateTime.now)
  end

  def archived?
    archived_at && archived_at < DateTime.now
  end
end
