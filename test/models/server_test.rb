# frozen_string_literal: true

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

  test '#documentation_url with no documentation_url value on manufacturer' do
    assert_nil servers(:pdu).documentation_url
  end

  test '#documentation_url with no numero value on manufacturer' do
    server = servers(:one)
    server.numero = nil

    assert_nil server.documentation_url
  end

  test '#documentation_url with documentation_url value on manufacturer' do
    assert servers(:one).documentation_url == "https://fortinet.com/CZ31535FEY/document"
  end
end
