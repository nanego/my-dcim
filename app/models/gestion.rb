class Gestion < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  has_many :servers

  scope :sorted, -> { order(Arel.sql('LOWER(name)')) }

  def to_s
    name.to_s
  end
end
