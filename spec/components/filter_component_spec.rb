# frozen_string_literal: true

require "rails_helper"

RSpec.describe FilterComponent, type: :component do
  let(:filter) { Filter.new(Frame.all, params) }
  let(:params) { {} }
  let(:component) { described_class.new(filter) }
  let(:block) {}

  let(:rendered_component) { render_inline(component, &block) }

  around do |example|
    with_request_url("/frames", &example)
  end

  context "without block" do
    it do
      expect(rendered_component.to_html).to have_tag("div.panel.panel-primary") do
        with_tag("div.panel-heading") do
          with_tag("h3.panel-title", text: I18n.t("filter_component.header.title"))
        end

        with_tag("div.panel-footer") do
          with_tag("input.btn.btn-primary.btn-sm", with: {
            type: :submit, form: :filters, value: I18n.t("filter_component.submit")
          })
          with_tag("a.btn.btn-secondary.btn-sm", text: I18n.t("filter_component.reset"))
          with_tag("span.pull-right", text: I18n.t("filter_component.total", count: Frame.count))
        end
      end
    end
  end

  context "with block" do
    let(:params) { { q: "My", u: "24" } }
    let(:block) do
      proc do |c|
        c.with_form do |f|
          buffer = ActiveSupport::SafeBuffer.new
          buffer << f.search_field(:q)
          buffer << f.text_field(:u)
        end
      end
    end

    it do
      # pp rendered_component.to_html

      expect(rendered_component.to_html).to have_tag("div.panel.panel-primary") do
        pp filter

        with_tag("div.panel-heading") do
          with_tag("h3.panel-title", text: "#{I18n.t("filter_component.header.title")} (2)")
        end

        with_tag("div.panel-body") do
          with_tag("form#filters.form-inline", with: { action: "", method: :get }) do
            with_tag("input", with: { type: :search, name: :q, value: "My" })
            with_tag("input", with: { type: :text, name: :u, value: "24" })
          end
        end

        with_tag("div.panel-footer") do
          with_tag("a.btn.btn-secondary.btn-sm", text: I18n.t("filter_component.reset"), with: { href: "http://test.host/frames" })
          with_tag("span.pull-right", text: I18n.t("filter_component.total_with_filters", total_count: Frame.count, results_count: 1))
        end
      end
    end
  end
end
