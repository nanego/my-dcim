# frozen_string_literal: true

require "rails_helper"

RSpec.describe Page::HeadingComponent, type: :component do
  let(:title) { "Title" }
  let(:breadcrumb_steps) { { "Sites" => "#url_sites" } }
  let(:back_button_url) { nil }
  let(:component) { described_class.new(title:, breadcrumb_steps:, back_button_url:) }
  let(:rendered_component) { render_inline(component, &block).to_html }

  let(:block) { nil }

  context "with title" do
    it "renders breadcrumb" do
      expect(rendered_component).to have_tag("ol.breadcrumb") do
        with_tag("a", href: "#url_sites", text: "Sites")
      end
    end

    it "renders heading" do
      expect(rendered_component).to have_tag("div.col-12.bg-body") do
        with_tag("div.d-flex") do
          with_tag("h1", text: "Title")
        end
      end
    end
  end

  context "without title" do
    let(:title) { nil }

    it "renders heading" do
      expect(rendered_component).to have_tag("div.col-12.bg-body") do
        with_tag("div.d-flex") do
          without_tag("h1", text: "Title")
        end
      end
    end
  end

  context "without back_button_url" do
    it "renders heading" do
      expect(rendered_component).to have_tag("div.col-12.bg-body") do
        with_tag("div.back-button-container") do
          without_tag("a.btn.back-button")
        end
      end
    end
  end

  context "with back_button_url" do
    let(:back_button_url) { "url" }

    it "renders heading" do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component).to have_tag("div.col-12.bg-body") do
        with_tag("div.back-button-container") do
          with_tag("a.btn.back-button") do
            with_tag("i.bi-chevron-left")
            with_tag("span.ms-2", text: "Retour")
          end
        end
      end
    end
  end

  context "with content" do
    let(:block) do
      proc do
        "<a href=\"#\" class=\"btn\">Button</a>".html_safe
      end
    end

    it "renders heading" do
      expect(rendered_component).to have_tag("div.col-12") do
        with_tag("a.btn", text: "Button")
      end
    end
  end

  context "with right content" do
    let(:block) do
      proc do |heading|
        heading.with_right_content do
          "<a href=\"#\" class=\"btn\">Button</a>".html_safe
        end
      end
    end

    it "renders heading" do
      expect(rendered_component).to have_tag("div.col-12") do
        with_tag("div.d-flex") do
          with_tag("a.btn", text: "Button")
        end
      end
    end
  end

  context "with all content and title" do
    let(:block) do
      proc do |heading|
        heading.with_right_content do
          "<a href=\"#\" class=\"btn\">Right Button</a>".html_safe
        end

        "<a href=\"#\" class=\"btn\">Button</a>".html_safe
      end
    end

    it "renders heading" do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component).to have_tag("div.col-12") do
        with_tag("a.btn", text: "Button")
        with_tag("div.d-flex") do
          with_tag("h1", text: "Title")
          with_tag("a.btn", text: "Right Button")
        end
      end
    end
  end
end
