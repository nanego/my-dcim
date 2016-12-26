namespace :init_pdus do

  desc "From Ports#cable_names to Pdus details"
  task :from_cablenames => :environment do
    Port.where("cablename ~ 'L....'").each do |port|
      puts "Cable #{port.cablename}"
      line = port.cablename[2]
      group = port.cablename[1]

      server = port.parent.try(:server)
      if server.frame
        frame = server.frame
        frame.pdu = Pdu.create(name: "PDU #{frame.to_s}") if frame.pdu.blank?
        frame.pdu.create_pdu_elements(line, group)
      end
    end
  end

end
