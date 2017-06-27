namespace :init_pdus do

  desc "From Ports#cable_names to Pdus details"
  task :from_cablenames => :environment do
    Port.where("cablename ~ 'L....'").each do |port|
      puts "Cable #{port.cablename}"
      line = port.cablename[2]
      group = port.cablename[1]

      server = port.cards_server.try(:server)
      if server.frame
        frame = server.frame
        frame.pdu = Pdu.create(name: "PDUs #{frame.to_s}") if frame.pdu.blank?
        frame.pdu.create_pdu_elements(line, group)
        group = group.to_i
        if group.odd? #Impair
          frame.pdu.create_pdu_elements(line, group+1)
        else
          frame.pdu.create_pdu_elements(line, group-1)
        end
      end
    end
  end

end
