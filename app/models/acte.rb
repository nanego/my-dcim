class Acte < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  has_many :serveurs

  def to_s
    title
  end

end
