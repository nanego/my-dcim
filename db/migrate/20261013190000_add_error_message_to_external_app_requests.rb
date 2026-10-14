# frozen_string_literal: true

class AddErrorMessageToExternalAppRequests < ActiveRecord::Migration[8.1]
  def change
    add_column :external_app_requests, :error_message, :string
  end
end
