# frozen_string_literal: true

# Update pdu lines

namespace :update_pdu_lines do

  desc "Update pdus groups"
  task :update_groups => :environment do

    alternate_frames_names = [1210, 1212, 1214, 1216, 1218, 1220, 1209, 1211, 1109, 1111, 1113, 1115, 1110, 1112, 1114, 1116, 2109, 2111, 2113, 2115, 2110, 2112, 2114, 2116]

    frames = Frame.where("name NOT IN (?)", alternate_frames_names.map {|id| "BA-#{id}"})

    puts "All frames : #{Frame.count}"

    puts "alternate_frames_names : #{alternate_frames_names.size}"

    puts "frames : #{frames.size}"

    # CREATE non-alternated PDUs
    #
    category = Category.find_or_create_by(name: 'Pdu')
    puts "ERROR: #{category}" unless category.valid?
    modele = Modele.find_or_create_by(name: 'Pdu 24 non alternés',
                                      category: category)
    puts "ERROR: #{modele}" unless modele.valid?
    enclosure = Enclosure.find_or_create_by(modele: modele,
                                            position: 1,
                                            display: 'vertical')
    puts "ERROR: #{enclosure}" unless enclosure.valid?
    type_composant = TypeComposant.find_by_name('SLOT')
    puts "ERROR: #{type_composant}" unless type_composant.valid?
    4.times do |i|
      line = [0, 1].include?(i) ? 'L1' : 'L2'
      composant = Composant.find_or_create_by(type_composant: type_composant,
                                              position: i + 1,
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

    frames.each do |frame|

      ['A', 'B'].each do |line_name|
        pdu_name = "PDU_#{frame}_#{line_name}"
        pdu = Server.find_by(frame: frame,
                             name: pdu_name)
        puts "#{frame} -> #{pdu_name}"
        if pdu
          pdu.modele = modele
          pdu.save
          puts "ERROR: #{pdu}" unless pdu.valid?
          pdu.cards.each do |card|
            current_position = card.composant.position
            card.composant = Composant.find_by(type_composant: type_composant,
                                               position: current_position,
                                               enclosure: enclosure)
            card.save
          end
        end
      end

    end

  end

end
