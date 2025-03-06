# frozen_string_literal: true

class RemoveServerStates < ActiveRecord::Migration[8.0]
  # Create status attribute on servers
  # migrate datas to new status (manage up and down)
  # drop server state table
  # remove changelog entries on serverstate

  def up

  end

  def down

  end
end
