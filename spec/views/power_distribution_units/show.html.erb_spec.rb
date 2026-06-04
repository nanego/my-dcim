# frozen_string_literal: true

require "rails_helper"

RSpec.describe "power_distribution_units/show" do
  before do
    assign(:power_distribution_unit, PowerDistributionUnit.create!(
                                       type_id: nil,
                                       bay_id: nil,
                                       side: 2,
                                       orientation: 3,
                                       name: "Name",
                                       slug: "Slug",
                                       ipmi_url: "Ipmi Url",
                                       serial_number: "Serial Number",
                                       comment: "MyText",
                                     ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Slug/)
    expect(rendered).to match(/Ipmi Url/)
    expect(rendered).to match(/Serial Number/)
    expect(rendered).to match(/MyText/)
  end
end
