class ServerState < ActiveRecord::Base

  has_many :servers

  scope :sorted, -> { order(:name) }

  def to_s
    name.to_s
  end

end
