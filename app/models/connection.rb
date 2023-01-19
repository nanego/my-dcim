# frozen_string_literal: true

class Connection < ApplicationRecord
  # FIXME: This optional: true is needed for time being to solve
  # the execute_movement (model MovedConnection) which call a port change
  # with the method connect_to_port (model Port)
  # there were the following issue
  # ActiveRecord::RecordNotSaved: Failed to remove the existing associated connection. The record failed to save after its foreign key was set to nil.
  # at line 55 of the method connect_to_port
  belongs_to :port, optional: true
  belongs_to :cable

  def paired_connection
    cable.connections.where.not(id: self.id).first
  end
end
