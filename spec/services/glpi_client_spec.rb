# frozen_string_literal: true

RSpec.describe GlpiClient, type: :service do
  let(:client) { described_class.new }

  describe "#computer_glpi_id" do
    subject(:id_ress) { client.computer_glpi_id(serial: "AZERTY") }

    it { expect(id_ress).to eq 4090 }
  end

  describe "#network_equipment_glpi_id" do
    subject(:id_ress) { client.network_equipment_glpi_id(serial: "AZERTY") }

    it { expect(id_ress).to eq 5000 }
  end

  describe "#computer" do
    subject(:computer) { client.computer(glpi_id: 4090) }

    it { expect(computer.id).to eq 4090 }
    it { expect(computer.serial).to eq "c27xmq1" }
    it { expect(computer.name).to eq "argoli" }
    it { expect(computer.hard_drives.size).to eq 17 }
    it { expect(computer.memories.size).to eq 16 }
    it { expect(computer.hard_drives_total_capacity).to eq 20_441_348 }
    it { expect(computer.memories_total_size).to eq 262_144 }
    it { expect(computer.processors.size).to eq 2 }
    it { expect(computer.processors.first[1]["designation"]).to eq "Intel(R) Xeon(R) CPU E5-2660 0 @ 2.20GHz" }
  end

  describe "#network_equipment" do
    subject(:network_equipment) { client.network_equipment(glpi_id: 5000) }

    it { expect(network_equipment.id).to eq 5000 }
    it { expect(network_equipment.serial).to eq "654321" }
    it { expect(network_equipment.name).to eq "network argoli" }
    it { expect(network_equipment.hard_drives.size).to eq 0 }
    it { expect(network_equipment.memories.size).to eq 0 }
    it { expect(network_equipment.hard_drives_total_capacity).to eq 0 }
    it { expect(network_equipment.memories_total_size).to eq 0 }
    it { expect(network_equipment.processors.size).to eq 0 }
    it { expect(network_equipment.processors).to eq({}) }
  end
end
