class CreateEnclosures < ActiveRecord::Migration[5.0]
  def change
    create_table :enclosures do |t|
      t.integer :modele_id
      t.integer :position

      t.timestamps
    end
    add_column :composants, :enclosure_id, :integer
    Modele.all.each do |modele|
      enclosure = Enclosure.new(position:1)
      modele.enclosures = [enclosure]
      modele.save
      Composant.where(:modele_id => modele.id).all.each do |composant|
        composant.enclosure_id = enclosure.id
        composant.save
      end
    end
    remove_column :composants, :modele_id, :integer
  end
end
