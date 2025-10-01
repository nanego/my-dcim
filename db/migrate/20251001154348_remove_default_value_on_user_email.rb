# frozen_string_literal: true

class RemoveDefaultValueOnUserEmail < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :email, from: "", to: nil
  end
end
