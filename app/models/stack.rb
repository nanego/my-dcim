# frozen_string_literal: true

class Stack < ApplicationRecord
  has_many :servers

  def to_s
    name
  end
end
