# frozen_string_literal: true

class NetsightApiConfig < ApplicationConfig
  config_name :netsight
  attr_config :url, :username, :password, local_server: false
  coerce_types local_server: :boolean
end
