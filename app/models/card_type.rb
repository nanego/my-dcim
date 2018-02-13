class CardType < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  belongs_to :port_type
  has_many :cards
  has_many :servers, through: :cards

  scope :sorted, -> { order('port_type_id', 'port_quantity asc') }

  def to_s
    name.nil? ? "" : name
  end

  def is_power_input?
    port_type.is_power_input?
  end

end
