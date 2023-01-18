# frozen_string_literal: true

class Cluster < ApplicationRecord
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  has_many :servers, dependent: :restrict_with_error

  scope :sorted, -> { order(Arel.sql('LOWER(name)')) }

  def to_s
    name.present? ? name : " "
  end
end
