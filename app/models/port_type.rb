class PortType < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  has_many :card_types

  def is_power_input?
    name=='ALIM'
  end

end
