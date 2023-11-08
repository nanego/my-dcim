class AddLatestMissingNotNullableToExistingTables < ActiveRecord::Migration[7.0]
  def change
    change_column_null :ports, :cart_id, false

    change_column_null :moved_connections, :port_froms_id, false

    change_column_null :modeles, :manufacturer_id, false
    change_column_null :modeles, :architecture_id, false

    change_column_null :connections, :port_id, false

    change_column_null :cards, :composant_id, false

    change_column_null :composants, :enclosure_id, false

    change_column_null :servers, :modele_id, false
  end
end
