# frozen_string_literal: true

require File.expand_path("../../test_helper", __FILE__)
require File.expand_path("../../../app/services/glpi_client", __FILE__)

class GlpiClientTest < ActiveSupport::TestCase
  def test_load_computer_details_by_serial
    client = GlpiClient.new
    computer = client.computer(serial: "AZERTY")
    assert computer.id == 4090
    assert computer.serial == "c27xmq1"
    assert computer.name == "argoli"
    assert computer.hard_drives.size == 17
    assert computer.memories.size == 16
    assert computer.hard_drives_total_capacity == 20_441_348
    assert computer.memories_total_size == 262_144
    assert computer.processors.size == 2
    assert computer.processors.first[1]["designation"] == "Intel(R) Xeon(R) CPU E5-2660 0 @ 2.20GHz"
  end
end
