# frozen_string_literal: true

class Permission < ApplicationRecord
  # has_many :domaines

  def to_s
    name
  end

  def domaine_ids
    []
  end

  def domaines
    []
  end
end
