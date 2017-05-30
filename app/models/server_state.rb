class ServerState < ActiveRecord::Base

  has_many :servers

  def to_s
    name.nil? ? "" : name
  end

end
