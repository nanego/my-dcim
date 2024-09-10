# frozen_string_literal: true

require "rails_helper"

RSpec.describe Page::HeadingComponent, type: :component do
  let(:component) { described_class.new(title: "Title") }
  let(:rendered_component) { render_inline(component, &block).to_html }

  let(:block) do
    proc do |heading|
      heading.with_extra_buttons do
        "<a href=\"#\" class=\"btn\">Button</a>".html_safe
      end
    end
  end

  it do # rubocop:disable RSpec/ExampleLength
    expect(rendered_component).to have_tag("div.col-12") do
      with_tag("div.d-flex") do
        with_tag("a.btn") do
          with_tag("span.bi-chrevron-left")
          with_tag("span.d-none", text: "Retour")
        end
        with_tag("h1.text-center", text: "Title")
        with_tag("div.align-self-center") do
          with_tag("a.btn", text: "Button")
          with_tag("a.btn", text: "Modifier")
        end
      end
    end
  end
end
