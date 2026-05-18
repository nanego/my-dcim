# frozen_string_literal: true

require "rails_helper"

RSpec.describe "power_distribution_unit_types/show" do
  before do
    assign(:power_distribution_unit_type, PowerDistributionUnitType.create!(
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
                                          ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Documentation Url/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/3/)
  end
end
