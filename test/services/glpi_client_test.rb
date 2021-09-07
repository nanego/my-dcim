require File.expand_path("../../test_helper", __FILE__)
require File.expand_path("../../../app/services/glpi_client", __FILE__)

class GlpiClientTest < ActiveSupport::TestCase

  def test_load_computer_details_by_serial
    client = GlpiClient.new
    response = client.computer(serial: 'AZERTY')
    assert response["id"], "4090"
    assert response["serial"], "c27xmq1"
    assert response["name"], "argoli"
  end

end
