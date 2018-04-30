class ServerState < ActiveRecord::Base

  has_many :servers

  def to_s
    name.to_s
  end

end
