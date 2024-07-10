# frozen_string_literal: true

namespace :sync_glpi_data do

  desc "Sync all servers with GLPI records"
  task :sync_all_servers => :environment do

    client = GlpiClient.new

    servers = Server.no_pdus

    puts "Synchonizing #{servers.count} servers with GLPI records:"

    servers.each_with_index do |server, index|
      puts "Processed #{index + 1} servers so far" if (index + 1) % 25 == 0
      sync_server(server, client)
    end

  end

  task :clear_all_external_records => :environment do
      ExternalAppRecord.destroy_all
  end

  def sync_server(server, client)

    params = [
      "with_devices=false", # Only for [Computer, NetworkEquipment, Peripheral, Phone, Printer], retrieve the associated components. Optional.
      "with_disks=false", # Only for Computer, retrieve the associated file-systems. Optional.
      "with_softwares=false", # Only for Computer, retrieve the associated software's installations. Optional.
      "with_connections=false", # Only for Computer, retrieve the associated direct connections (like peripherals and printers) .Optional.
      "with_networkports=false", # Retrieve all network's connections and advanced network's informations. Optional.
      "with_infocoms=false", # Retrieve financial and administrative informations. Optional.
      "with_contracts=false", # Retrieve associated contracts. Optional.
      "with_documents=false", # Retrieve associated external documents. Optional.
      "with_tickets=false", # Retrieve associated ITIL tickets. Optional.
      "with_problems=false", # Retrieve associated ITIL problems. Optional.
      "with_changes=false", # Retrieve associated ITIL changes. Optional.
      "with_notes=false", # Retrieve Notes. Optional.
      "with_logs=false", # Retrieve historical. Optional.
    ]

    computer = client.computer(serial: server.numero, params: params)
    record = ExternalAppRecord.find_or_create_by(server: server)
    if computer.present?
      updated = record.update({ external_name: computer.name, external_id: computer.id, external_serial: computer.serial })
    else
      updated = record.update({ external_name: '', external_id: '', external_serial: '' })
    end
    puts "Server ##{server.id} #{server.name} NOT updated" unless updated
  end

end
