# frozen_string_literal: true

class Gestion < ApplicationRecord
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  has_changelog

  has_many :servers, dependent: :restrict_with_error

  scope :sorted, -> { order(Arel.sql('LOWER(name)')) }

  def to_s
    name.to_s
  end
end
