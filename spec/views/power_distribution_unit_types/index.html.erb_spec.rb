# frozen_string_literal: true

require "rails_helper"

RSpec.describe "power_distribution_unit_types/index" do
  before do
    assign(:power_distribution_unit_types, [
             PowerDistributionUnitType.create!(
               manufacturer: nil,
               name: "Name",
               current_type: 2,
               documentation_url: "Documentation Url",
               meter_global: false,
               meter_per_socket: false,
               meter_per_circuit: false,
               socket_control: false,
               socket_lock: false,
               ip_snmp: false,
               ip_modbus: false,
               ip_ssh: false,
               ip_webui: false,
               rs485_modbus: false,
               max_power_per_circuit: 3,
             ),
             PowerDistributionUnitType.create!(
               manufacturer: nil,
               name: "Name",
               current_type: 2,
               documentation_url: "Documentation Url",
               meter_global: false,
               meter_per_socket: false,
               meter_per_circuit: false,
               socket_control: false,
               socket_lock: false,
               ip_snmp: false,
               ip_modbus: false,
               ip_ssh: false,
               ip_webui: false,
               rs485_modbus: false,
               max_power_per_circuit: 3,
             ),
           ])
  end

  it "renders a list of power_distribution_unit_types" do
    render
    cell_selector = "div>p"
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Name"), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Documentation Url"), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
  end
end
