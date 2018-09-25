# Update ports position when the model is 6520 [SAN Switch - Network Bay]

namespace :update_ports_position do

  desc "Update ports position by name"
  task :update_by_name => :environment do

    model_name = "X670-48x"
    first_position = 1 # 0 or 1

    switchs = Server.joins(:modele).where('modeles.name = ?', model_name)

    switchs.each do |switch|
      puts "******" + switch.name
      puts switch.ports.size.to_s + " ports"
      array = []

      # Set correct position
      switch.ports.each do |port|
        if port.card.composant.name == 'CM' && port.cable_name.present?
          array << "#{port.cable_name} / #{port.position - 1}"
          port.position = port.cable_name[1..-1].to_i + (1 - first_position)
          port.save
        end
      end

      # Clean ports without connection (avoid duplications on same position)
      (switch.ports - switch.ports.with_connection).each {|port|port.destroy}
      # Create missing ports
      switch.create_missing_ports

      puts array.sort.inspect
    end

  end

end
