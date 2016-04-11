class CoupleBaie < ActiveRecord::Base

  belongs_to :baie_one, :class_name => "Baie"
  belongs_to :baie_two, :class_name => "Baie"

end
