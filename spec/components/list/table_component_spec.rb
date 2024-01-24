# frozen_string_literal: true

require "rails_helper"

RSpec.describe List::TableComponent, type: :component do
  let(:component) { described_class.new }
  let(:rendered_component) { render_inline(component, &block).to_html }

  let(:block) do
    proc do |table|
      table.with_head do
        "<tr><th>name</th></tr>".html_safe
      end
      table.with_body do
        "<tr><td>John</td></tr>".html_safe
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
          with_tag("tr") do
            with_tag("td", text: "John")
          end
        end
      end
    end
  end
end
