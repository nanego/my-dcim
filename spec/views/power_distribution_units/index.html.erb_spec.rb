# frozen_string_literal: true

require "rails_helper"

RSpec.describe "power_distribution_units/index" do
  before do
    assign(:power_distribution_units, [
             PowerDistributionUnit.create!(
               type_id: nil,
               bay_id: nil,
               side: 2,
               orientation: 3,
               name: "Name",
               slug: "Slug",
               ipmi_url: "Ipmi Url",
               serial_number: "Serial Number",
               comment: "MyText",
             ),
             PowerDistributionUnit.create!(
               type_id: nil,
               bay_id: nil,
               side: 2,
               orientation: 3,
               name: "Name",
               slug: "Slug",
               ipmi_url: "Ipmi Url",
               serial_number: "Serial Number",
               comment: "MyText",
             ),
           ])
  end

  it "renders a list of power_distribution_units" do
    render
    cell_selector = "div>p"
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Name"), count: 2
    assert_select cell_selector, text: Regexp.new("Slug"), count: 2
    assert_select cell_selector, text: Regexp.new("Ipmi Url"), count: 2
    assert_select cell_selector, text: Regexp.new("Serial Number"), count: 2
    assert_select cell_selector, text: Regexp.new("MyText"), count: 2
  end
end
