# frozen_string_literal: true

class CardType < ApplicationRecord
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  belongs_to :port_type
  delegate :is_power_input?, to: :port_type, :allow_nil => true

  has_many :cards
  has_many :servers, through: :cards

  scope :sorted, -> { order('port_type_id', 'port_quantity asc') }

  def to_s
    name.to_s
  end
end
