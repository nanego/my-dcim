class Card < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  belongs_to :port_type
  has_many :cards_servers
  has_many :servers, through: :cards_servers

  def to_s
    name.nil? ? "" : name
  end

end
