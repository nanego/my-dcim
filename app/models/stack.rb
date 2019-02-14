class Stack < ActiveRecord::Base

  has_many :servers

  def to_s
    name
  end

end
