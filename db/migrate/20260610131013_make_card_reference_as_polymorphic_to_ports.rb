# frozen_string_literal: true

class MigrationPort < ActiveRecord::Base
  self.table_name = :ports
end

class MakeCardReferenceAsPolymorphicToPorts < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :ports, :cards

    change_table :ports, bluk: true do |t|
      t.rename :card_id, :attachable_id
      t.string :attachable_type

      t.index %i[attachable_id attachable_type]

      up_only do
        MigrationPort.update_all(attachable_type: "Card")
      end

      t.change_null(:attachable_type, false)
    end
  end
end
