# frozen_string_literal: true

require "rails_helper"

RSpec.describe Page::HeadingComponent, type: :component do
  let(:resource) { sites(:one) }
  let(:title) { "Title" }
  let(:breadcrumb_steps) { { "Sites" => "#url_sites", resource.name => "#url_site" } }
  let(:component) { described_class.new(resource:, title:, breadcrumb_steps:) }
  let(:rendered_component) { render_inline(component, &block).to_html }

  let(:block) do
    proc do |heading|
      heading.with_extra_buttons do
        "<a href=\"#\" class=\"btn\">Button</a>".html_safe
      end
    end
  end

  context "with :show style and extra_buttons" do
    it "renders breadcrumb" do
      expect(rendered_component).to have_tag("ol.breadcrumb") do
        with_tag("a", href: "#url_sites", text: "Sites")
        with_tag("a", href: "#url_site", text: resource.name)
      end
    end

    it "renders heading" do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component).to have_tag("div.col-12") do
        with_tag("div.d-flex") do
          with_tag("a.btn") do
            with_tag("span.bi-chevron-left")
            with_tag("span.d-none", text: "Retour")
          end
          with_tag("h1.text-center", text: "Title")
          with_tag("div.align-self-center") do
            with_tag("a.btn", text: "Button")
            with_tag("a.btn", text: "Modifier")
            without_tag("a.btn", text: "Voir")
          end
          without_tag("span.flex-grow-1", count: 2)
        end
      end
    end
  end

  context "with :show style and without extra_buttons" do
    let(:block) { nil }

    it "renders heading" do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component).to have_tag("div.col-12") do
        with_tag("div.d-flex") do
          with_tag("div.align-self-center") do
            without_tag("a.btn", text: "Button")
          end
        end
      end
    end
  end

  context "with :create style" do
    let(:component) { described_class.new(resource:, title:, breadcrumb_steps:, style: :create) }

    it "renders heading" do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component).to have_tag("div.col-12") do
        with_tag("div.d-flex") do
          with_tag("span.flex-grow-1") do
            with_tag("a.btn") do
              with_tag("span.bi-chevron-left")
              with_tag("span.d-none", text: "Retour")
            end
          end
          with_tag("span.flex-grow-1", count: 2)
          with_tag("h1.text-center", text: "Title")
          without_tag("div.align-self-center") do
            with_tag("a.btn", text: "Button")
            with_tag("a.btn", text: "Modifier")
            with_tag("a.btn", text: "Voir")
          end
        end
      end
    end
  end

  context "with :edit style" do
    let(:component) { described_class.new(resource:, title:, breadcrumb_steps:, style: :edit) }

    it "renders heading" do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component).to have_tag("div.col-12") do
        with_tag("div.d-flex") do
          with_tag("a.btn") do
            with_tag("span.bi-chevron-left")
            with_tag("span.d-none", text: "Retour")
          end
          with_tag("h1.text-center", text: "Title")
          with_tag("div.align-self-center") do
            with_tag("a.btn", text: "Button")
            with_tag("a.btn", text: "Voir")
            without_tag("a.btn", text: "Modifier")
          end
          without_tag("span.flex-grow-1", count: 2)
        end
      end
    end
  end

  context "with not valid style" do
    let(:component) { described_class.new(resource:, title:, breadcrumb_steps:, style: :unknown) }

    it { expect { component }.to raise_error(ArgumentError) }
  end
end
