# frozen_string_literal: true

require "rails_helper"

RSpec.describe "power_distribution_unit_types/edit" do
  let(:power_distribution_unit_type) do
    PowerDistributionUnitType.create!(
      manufacturer: nil,
      name: "MyString",
      current_type: 1,
      documentation_url: "MyString",
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
      max_power_per_circuit: 1,
    )
  end

  before do
    assign(:power_distribution_unit_type, power_distribution_unit_type)
  end

  it "renders the edit power_distribution_unit_type form" do
    render

    assert_select "form[action=?][method=?]", power_distribution_unit_type_path(power_distribution_unit_type), "post" do
      assert_select "input[name=?]", "power_distribution_unit_type[manufacturer_id]"

      assert_select "input[name=?]", "power_distribution_unit_type[name]"

      assert_select "input[name=?]", "power_distribution_unit_type[current_type]"

      assert_select "input[name=?]", "power_distribution_unit_type[documentation_url]"

      assert_select "input[name=?]", "power_distribution_unit_type[meter_global]"

      assert_select "input[name=?]", "power_distribution_unit_type[meter_per_socket]"

      assert_select "input[name=?]", "power_distribution_unit_type[meter_per_circuit]"

      assert_select "input[name=?]", "power_distribution_unit_type[socket_control]"

      assert_select "input[name=?]", "power_distribution_unit_type[socket_lock]"

      assert_select "input[name=?]", "power_distribution_unit_type[ip_snmp]"

      assert_select "input[name=?]", "power_distribution_unit_type[ip_modbus]"

      assert_select "input[name=?]", "power_distribution_unit_type[ip_ssh]"

      assert_select "input[name=?]", "power_distribution_unit_type[ip_webui]"

      assert_select "input[name=?]", "power_distribution_unit_type[rs485_modbus]"

      assert_select "input[name=?]", "power_distribution_unit_type[max_power_per_circuit]"
    end
  end
end
