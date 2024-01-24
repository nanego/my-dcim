# frozen_string_literal: true

class Category < ApplicationRecord
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  has_changelog

  has_many :modeles, dependent: :restrict_with_error

  scope :sorted, -> { order(:name) }

  def to_s
    name.to_s
  end

  def pdu?
    name == "Pdu"
  end
end
