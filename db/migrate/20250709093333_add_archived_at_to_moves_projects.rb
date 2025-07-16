# frozen_string_literal: true

class AddArchivedAtToMovesProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :moves_projects, :archived_at, :datetime
  end
end
