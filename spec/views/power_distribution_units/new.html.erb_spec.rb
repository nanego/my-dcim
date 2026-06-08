# frozen_string_literal: true

require "rails_helper"

RSpec.describe "power_distribution_units/new" do
  before do
    assign(:power_distribution_unit, PowerDistributionUnit.new(
                                       type_id: nil,
                                       bay_id: nil,
                                       side: 1,
                                       orientation: 1,
                                       name: "MyString",
                                       slug: "MyString",
                                       ipmi_url: "MyString",
                                       serial_number: "MyString",
                                       comment: "MyText",
                                     ))
  end

  it "renders new power_distribution_unit form" do
    render

    assert_select "form[action=?][method=?]", power_distribution_units_path, "post" do
      assert_select "input[name=?]", "power_distribution_unit[type_id]"

      assert_select "input[name=?]", "power_distribution_unit[bay_id]"

      assert_select "input[name=?]", "power_distribution_unit[side]"

      assert_select "input[name=?]", "power_distribution_unit[orientation]"

      assert_select "input[name=?]", "power_distribution_unit[name]"

      assert_select "input[name=?]", "power_distribution_unit[slug]"

      assert_select "input[name=?]", "power_distribution_unit[ipmi_url]"

      assert_select "input[name=?]", "power_distribution_unit[serial_number]"

      assert_select "textarea[name=?]", "power_distribution_unit[comment]"
    end
  end
end
