# frozen_string_literal: true

class MigrationCategory < ActiveRecord::Base
  self.table_name = :categories
end

class MigrationModele < ActiveRecord::Base
  self.table_name = :modeles

  belongs_to :category, class_name: "MigrationCategory"
end

class MigrationEnclosure < ActiveRecord::Base
  self.table_name = :enclosures
end

class MigrationTypeComposant < ActiveRecord::Base
  self.table_name = :type_composants
end

class MigrationComposant < ActiveRecord::Base
  self.table_name = :composants
end

class MigrationPortType < ActiveRecord::Base
  self.table_name = :port_types
end

class MigrationCardType < ActiveRecord::Base
  self.table_name = :card_types
end

class MigrationFrame < ActiveRecord::Base
  self.table_name = :frames
end

class MigrationServer < ActiveRecord::Base
  self.table_name = :servers
end

class MigrationCard < ActiveRecord::Base
  self.table_name = :cards
end

class AddAttributesToServers < ActiveRecord::Migration[5.0]
  def up
    add_column :servers, :side, :string
    add_column :servers, :color, :string

    drop_table :pdu_outlet_groups
    drop_table :pdu_lines
    drop_table :pdus

    init_pdus_for_every_frames
  end

  def down; end

  private

  def init_pdus_for_every_frames
    MigrationCategory.reset_column_information
    MigrationModele.reset_column_information

    category = MigrationCategory.create(name: 'Pdu')
    puts "ERROR: #{category}" unless category.valid?
    modele = MigrationModele.create(name: 'Pdu 24',
                                    category: category)
    puts "ERROR: #{modele}" unless modele.valid?
    enclosure = MigrationEnclosure.create(modele: modele,
                                          position: 1,
                                          display: 'vertical')
    puts "ERROR: #{enclosure}" unless enclosure.valid?
    type_composant = MigrationTypeComposant.find_by_name('SLOT')
    puts "ERROR: #{type_composant}" unless type_composant.valid?
    4.times do |i|
      line = (i + 1).odd? ? 'L1' : 'L2'
      composant = MigrationComposant.create(type_composant: type_composant,
                                            position: i + 1,
                                            enclosure: enclosure,
                                            name: "ALIM_#{line}")
      puts "ERROR: #{composant}" unless composant.valid?
    end

    port_type = MigrationPortType.find_by_name('ALIM')
    puts "ERROR: #{port_type}" unless port_type.valid?
    card_type = MigrationCardType.find_or_create_by(name: '6ALIM',
                                                    port_quantity: 6,
                                                    port_type: port_type)
    puts "ERROR: #{card_type}" unless card_type.valid?

    MigrationFrame.all.find_each do |frame|
      %w[A B].each do |line_name|
        pdu_name = "PDU_#{frame}_#{line_name}"
        pdu = MigrationServer.create(frame: frame,
                                     modele: modele,
                                     numero: pdu_name,
                                     name: pdu_name,
                                     side: Pdu.calculated_side(frame, line_name),
                                     color: line_name == 'A' ? 'J' : 'B')
        puts "ERROR: #{pdu}" unless pdu.valid?
        enclosure.composants.each do |composant|
          card = MigrationCard.create(card_type: card_type,
                                      server: pdu,
                                      composant: composant)
          puts "ERROR: #{card}" unless card.valid?
        end
      end
    end
  end
end
