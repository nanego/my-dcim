# frozen_string_literal: true

module Netsight
  class Client
    Link = Data.define(:if_name, :peer_ip, :peer_if_name, :protocol, :type, :status)
  end
end
