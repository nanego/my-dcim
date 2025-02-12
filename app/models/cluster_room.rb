# frozen_string_literal: true

class ClusterRoom < ApplicationRecord
  belongs_to :cluster
  belongs_to :room
end
