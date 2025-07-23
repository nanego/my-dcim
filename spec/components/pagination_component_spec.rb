# frozen_string_literal: true

require "rails_helper"

RSpec.describe PaginationComponent, type: :component do
  let(:rendered_component) { render_inline(component) }
  let(:component) { described_class.new(pagy:, params: {}, limit: 100) }
  let(:pagy) { Pagy.new(count: 101) }

  before do
    allow(component).to receive(:url_for).and_return("/path")
  end

  context "with several pages" do
    it do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component.to_html).to have_tag("div.pagination-component") do
        with_tag("nav.pagy-bootstrap")
        with_tag("select#items_per_page") do
          User::AVAILABLE_ITEMS_PER_PAGE.each do |item|
            with_tag("option", text: item)
          end
        end
      end
    end
  end

  context "with no pages" do
    let(:pagy) { Pagy.new(count: 1) }

    it do
      expect(rendered_component.to_html).to have_tag("div.pagination-component") do
        without_tag("nav.pagy-bootstrap.nav")
        with_tag("select#items_per_page")
      end
    end
  end
end
