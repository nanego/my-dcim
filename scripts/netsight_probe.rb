#!/usr/bin/env ruby
# frozen_string_literal: true

# Explores the Netsight GraphQL API. Standalone, stdlib only.
#
#   export NETSIGHT_URL=https://...  # optional, defaults to DEFAULT_URL
#   export NETSIGHT_USERNAME=apiread
#   export NETSIGHT_PASSWORD=...     # prompted if missing
#
#   ruby scripts/netsight_probe.rb devices
#   ruby scripts/netsight_probe.rb ports --ip 10.1.2.3
#   ruby scripts/netsight_probe.rb port --ip 10.1.2.3 --if-index 2024
#   ruby scripts/netsight_probe.rb query '{ network { devices { ip } } }'
#
# Net::HTTP ignores https_proxy, hence the explicit --proxy / NETSIGHT_PROXY fallback.

require "io/console"
require "json"
require "net/http"
require "optparse"
require "uri"

DEFAULT_URL = "https://supervision-reseau-ac.cs.e2.rie.gouv.fr/netsight"

ENTITY_PORT_FIELDS = %w[ifIndex ifName formattedOperStatus formattedSpeed isLag isLagMaster isLagContributor lagMasterIndex lagId ifAlias].freeze
DATA_PORT_FIELDS = %w[ifIndex tagged untagged portPvid].freeze
PORT_COLUMNS = %w[ifIndex ifName formattedOperStatus formattedSpeed lag tagged untagged portPvid ifAlias].freeze

MAX_LISTED_VLANS = 8

options = {
  url: ENV.fetch("NETSIGHT_URL", DEFAULT_URL),
  proxy: ENV["NETSIGHT_PROXY"] || ENV["https_proxy"] || ENV.fetch("HTTPS_PROXY", nil),
  insecure: false,
  json: false,
}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$PROGRAM_NAME} devices|ports|port|query [QUERY] [options]"
  opts.on("--ip IP", "Device IP (ports, port)") { |v| options[:ip] = v }
  opts.on("--if-index N", Integer, "Port ifIndex (port)") { |v| options[:if_index] = v }
  opts.on("--url URL", "GraphQL endpoint (default: #{DEFAULT_URL})") { |v| options[:url] = v }
  opts.on("--proxy URL", "HTTP proxy, 'none' to disable") { |v| options[:proxy] = v }
  opts.on("--insecure", "Skip TLS certificate verification") { options[:insecure] = true }
  opts.on("--json", "Print the raw JSON response") { options[:json] = true }
end
parser.parse!

command = ARGV.shift
abort(parser.help) unless %w[devices ports port query].include?(command)

def format_cell(value)
  return value.to_s unless value.is_a?(Array)
  return value.join(", ") if value.size <= MAX_LISTED_VLANS

  "#{value.first(MAX_LISTED_VLANS).join(", ")}, ... (#{value.size})"
end

def lag_label(port)
  if port["isLagMaster"] || port["isLag"]
    "master #{port["lagId"]}".strip
  elsif port["isLagContributor"]
    "-> #{port["lagMasterIndex"]}"
  end
end

def print_table(rows, columns)
  rows = rows.map { |row| columns.to_h { |c| [c, format_cell(row[c])] } } # rubocop:disable Rails/IndexWith -- no ActiveSupport here
  widths = columns.to_h { |c| [c, ([c] + rows.map { |row| row[c] }).map(&:length).max] } # rubocop:disable Rails/IndexWith -- no ActiveSupport here
  puts columns.map { |c| c.ljust(widths[c]) }.join("  ")
  rows.each { |row| puts columns.map { |c| row[c].ljust(widths[c]) }.join("  ").rstrip }
end

def require_option!(options, key, parser)
  abort("--#{key.to_s.tr("_", "-")} is required\n\n#{parser.help}") if options[key].nil?
end

query = case command
        when "devices"
          "{ network { devices { up ip sysName nickName sysLocation } } }"
        when "ports"
          require_option!(options, :ip, parser)
          %({ network { device(ip: "#{options[:ip]}") { ip sysName sysLocation entityData { allPorts { #{ENTITY_PORT_FIELDS.join(" ")} } } deviceData { ports { #{DATA_PORT_FIELDS.join(" ")} } } } } })
        when "port"
          require_option!(options, :ip, parser)
          require_option!(options, :if_index, parser)
          port = "port(ifIndex: #{options[:if_index]})"
          %({ network { device(ip: "#{options[:ip]}") { ip sysName sysLocation ) +
          %(entityData { #{port} { #{ENTITY_PORT_FIELDS.join(" ")} } } deviceData { #{port} { #{DATA_PORT_FIELDS.join(" ")} } } } } })
        when "query"
          ARGV.shift || abort("query needs a GraphQL query string")
        end

username = ENV["NETSIGHT_USERNAME"] || "apiread"
password = ENV["NETSIGHT_PASSWORD"] || $stdin.getpass("Netsight password for #{username}: ")

uri = URI(options[:url])
uri.query = URI.encode_www_form(query:)

request = Net::HTTP::Get.new(uri)
request.basic_auth(username, password)
request["Accept"] = "application/json"

proxy = options[:proxy].to_s.empty? || options[:proxy] == "none" ? nil : URI(options[:proxy])

begin
  http = Net::HTTP.new(uri.hostname, uri.port, proxy&.hostname, proxy&.port, proxy&.user, proxy&.password)
  http.use_ssl = uri.scheme == "https"
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE if options[:insecure]
  http.open_timeout = 10
  http.read_timeout = 60
  response = http.request(request)
rescue StandardError => e
  abort("Request failed: #{e.class}: #{e.message}")
end

abort("HTTP #{response.code}: #{response.body.to_s[0, 500]}") unless response.is_a?(Net::HTTPSuccess)

begin
  body = JSON.parse(response.body)
rescue JSON::ParserError
  abort("Not JSON (Content-Type: #{response["Content-Type"]}):\n#{response.body.to_s[0, 500]}")
end

if options[:json] || command == "query"
  puts JSON.pretty_generate(body)
  exit
end

# GraphQL reports query errors with a 200 status
if body["errors"]
  warn JSON.pretty_generate(body["errors"])
  exit 1
end

network = body.dig("data", "network") || {}

case command
when "devices"
  devices = (network["devices"] || []).sort_by { |d| d["sysName"].to_s }
  print_table(devices, %w[up ip sysName nickName sysLocation])
  puts "\n#{devices.size} devices"
when "ports", "port"
  device = network["device"]
  abort("No device found for #{options[:ip]}") if device.nil?

  puts "#{device["sysName"]} (#{device["ip"]}) - #{device["sysLocation"]}"
  entity = device["entityData"] || {}
  data = device["deviceData"] || {}
  ports = Hash.new { |hash, if_index| hash[if_index] = {} }
  (entity["allPorts"] || [entity["port"]].compact).each { |p| ports[p["ifIndex"]].merge!(p) }
  (data["ports"] || [data["port"]].compact).each { |p| ports[p["ifIndex"]].merge!(p) }
  ports.each_value { |p| p["lag"] = lag_label(p) }
  print_table(ports.values.sort_by { |p| p["ifIndex"].to_i }, PORT_COLUMNS)
end
