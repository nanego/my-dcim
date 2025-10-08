# frozen_string_literal: true

require "rails_helper"

RSpec.describe PaginationComponent, type: :component do
  let(:rendered_component) { render_inline(component) }
  let(:component) { described_class.new(pagy:) }
  let(:pagy) { Pagy.new(count: 101, limit: 100) }

  before do
    allow(component).to receive(:url_for).and_return("/path")
  end

  it do # rubocop:disable RSpec/ExampleLength
    expect(rendered_component.to_html).to have_tag("div.pagination-component") do
      with_tag("nav.pagy-bootstrap")
      with_tag("select#limit") do
        User::AVAILABLE_ITEMS_PER_PAGE.each do |item|
          with_tag("option", text: item)
        end
      end
    end
  end
end
