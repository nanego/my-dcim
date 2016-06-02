class CoupleBaie < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  belongs_to :baie_one, :class_name => "Baie"
  belongs_to :baie_two, :class_name => "Baie"

end
