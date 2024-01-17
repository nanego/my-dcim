# frozen_string_literal: true

require "rails_helper"

RSpec.describe List::DataTableComponent, type: :component do
  let(:component) { described_class.new(data) }
  let(:rendered_component) { render_inline(component, &block).to_html }

  let(:data) do
    [
      { product: "Emerald Silk Gown", price: "$875.00", sku: 124689, qty: 140, sales: "$122,500.00" },
      { product: "Mauve Cashmere Scarf", price: "$230.00", sku: 124533, qty: 83, sales: "$19,090.00" },
      { product: "Navy Merino Wool Blazer with khaki chinos and yellow belt", price: "$445.00", sku: 124518, qty: 32, sales: "$14,240.00" },
    ]
  end

  let(:block) do
    proc do |table|
      table.with_column("name") do |row|
        row[:product]
      end
    end
  end

  it do
    expect(rendered_component).to have_tag("div.table-responsive") do
      with_tag("table.table") do
        with_tag("thead") do
          with_tag("tr") do
            with_tag("th", text: "name")
          end
        end
        with_tag("tbody") do
          data.each do |row|
            with_tag("tr") do
              with_tag("td", text: row[:product])
            end
          end
        end
      end
    end
  end
end
