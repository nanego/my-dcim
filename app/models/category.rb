class Category < ActiveRecord::Base

  has_many :modeles

  def to_s
    title
  end
end
