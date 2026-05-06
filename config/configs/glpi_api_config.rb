# frozen_string_literal: true

class GlpiApiConfig < ApplicationConfig
  config_name :glpi
  attr_config :api_url, :apikey, :url, local_server: false
  coerce_types local_server: :boolean
end
