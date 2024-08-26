class CreateExternalAppRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :external_app_requests do |t|
      t.string :status
      t.integer :progress
      t.string :external_app_name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
