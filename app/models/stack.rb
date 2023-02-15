class Stack < ActiveRecord::Base

  has_many :servers, dependent: :restrict_with_error

  def to_s
    name
  end

end
