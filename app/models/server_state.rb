class ServerState < ActiveRecord::Base

  has_many :servers

  def to_s
    title
  end

end
