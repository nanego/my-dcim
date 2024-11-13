# frozen_string_literal: true

require "rails_helper"

RSpec.describe ButtonComponent, type: :component do
  let(:title) { "Title" }
  let(:url) { "/url" }
  let(:component) { described_class.new(title, url:) }
  let(:rendered_component) { render_inline(component).to_html }

  context "with title and url" do
    it do
      expect(rendered_component).to have_tag("a.btn-default.btn-default", href: "/url", title: "Title") do
        without_tag("span.bi")
        with_tag("span.ms-1:not(.d-none)", text: "Title")
      end
    end
  end

  describe "testing variant parameter" do
    context "with existing variant" do
      let(:component) { described_class.new(title, url:, variant: :primary) }

      it { expect(rendered_component).to have_tag("a.btn-default.btn-primary", href: "/url", title: "Title") }
    end

    context "with non-existing variant" do
      let(:component) { described_class.new(title, url:, variant: :unknown) }

      it { expect { component }.to raise_error(ArgumentError) }
    end
  end

  describe "testing size parameter" do
    context "with existing size" do
      let(:component) { described_class.new(title, url:, size: :sm) }

      it { expect(rendered_component).to have_tag("a.btn-default.btn-sm", href: "/url", title: "Title") }
    end

    context "with non-existing size" do
      let(:component) { described_class.new(title, url:, size: :unknown) }

      it { expect { component }.to raise_error(ArgumentError) }
    end
  end

  context "with an icon" do
    let(:component) { described_class.new(title, url:, icon: "eye") }

    it do
      expect(rendered_component).to have_tag("a.btn-default.btn-default", href: "/url", title: "Title") do
        with_tag("span.bi-eye")
      end
    end
  end

  context "with is_responsive set to true" do
    let(:component) { described_class.new(title, url:, is_responsive: true) }

    it do
      expect(rendered_component).to have_tag("a.btn-default.btn-default", href: "/url", title: "Title") do
        with_tag("span.ms-1.d-none", text: "Title")
      end
    end
  end

  context "with extra_classes" do
    let(:component) { described_class.new(title, url:, extra_classes: "extra_class") }

    it do
      expect(rendered_component).to have_tag("a.btn-default.btn-default.extra_class", href: "/url", title: "Title")
    end
  end

  context "with html_options" do
    let(:component) { described_class.new(title, url:, method: :delete) }

    it do
      expect(rendered_component).to have_tag("a.btn-default.btn-default[data-method='delete']", href: "/url")
    end
  end

  context "with a specific title for tooltip passed through html_options" do
    let(:component) { described_class.new(title, url:, data: { tooltip_title: "Tooltip title" }) }

    it do
      expect(rendered_component).to have_tag("a.btn-default.btn-default", title: "Tooltip title")
    end
  end
end
