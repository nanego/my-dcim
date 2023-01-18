# frozen_string_literal: true

class AddAttributesToServers < ActiveRecord::Migration[5.0]
  def up
    add_column :servers, :side, :string
    add_column :servers, :color, :string

    drop_table :pdu_outlet_groups
    drop_table :pdu_lines
    drop_table :pdus

    init_pdus_for_every_frames
  end

  def down
  end

  def init_pdus_for_every_frames
    category = Category.create(name: 'Pdu')
    puts "ERROR: #{category}" unless category.valid?
    modele = Modele.create(name: 'Pdu 24',
                           category: category)
    puts "ERROR: #{modele}" unless modele.valid?
    enclosure = Enclosure.create(modele: modele,
                                 position: 1,
                                 display: 'vertical')
    puts "ERROR: #{enclosure}" unless enclosure.valid?
    type_composant = TypeComposant.find_by_name('SLOT')
    puts "ERROR: #{type_composant}" unless type_composant.valid?
    4.times do |i|
      line = (i+1).odd? ? 'L1' : 'L2'
      composant = Composant.create(type_composant: type_composant,
                       position: i+1,
                       enclosure: enclosure,
                       name: "ALIM_#{line}")
      puts "ERROR: #{composant}" unless composant.valid?
    end

    port_type = PortType.find_by_name('ALIM')
    puts "ERROR: #{port_type}" unless port_type.valid?
    card_type = CardType.find_or_create_by(name: '6ALIM',
                                        port_quantity: 6,
                                        port_type: port_type)
    puts "ERROR: #{card_type}" unless card_type.valid?

    Frame.all.each do |frame|
      ['A','B'].each do |line_name|
        pdu_name = "PDU_#{frame}_#{line_name}"
        pdu = Server.create(frame: frame,
                            modele: modele,
                            numero: pdu_name,
                            name: pdu_name,
                            side: Pdu.calculated_side(frame, line_name),
                            color: line_name == 'A' ? 'J':'B' )
        puts "ERROR: #{pdu}" unless pdu.valid?
        enclosure.composants.each do |composant|
          card = Card.create(card_type: card_type,
                      server: pdu,
                      composant: composant)
          puts "ERROR: #{card}" unless card.valid?
        end
      end
    end
  end
end
