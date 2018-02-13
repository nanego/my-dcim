require File.expand_path("../../test_helper", __FILE__)

class ServerTest < ActiveSupport::TestCase

  test 'scope only_pdus' do
    assert_includes Server.only_pdus, servers(:pdu)
    refute_includes Server.only_pdus, servers(:one)
  end

  test 'scope no_puds' do
    refute_includes Server.no_pdus, servers(:pdu)
    assert_includes Server.no_pdus, servers(:one)
  end

end
