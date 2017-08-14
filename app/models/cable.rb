class Cable < ApplicationRecord

  has_many :connections, dependent: :destroy

end
