class Slot < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  belongs_to :composant
  belongs_to :server

  acts_as_list scope: [:composant_id, :server_id]

  def to_s
    valeur
  end
end
