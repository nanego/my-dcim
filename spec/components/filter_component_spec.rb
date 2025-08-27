# frozen_string_literal: true

require "rails_helper"

RSpec.describe FilterComponent, type: :component do
  let(:filter) { ProcessorFilter.new(Frame.all, params) }
  let(:params) { {} }
  let(:component) { described_class.new(filter) }
  let(:block) { nil }

  let(:rendered_component) { render_inline(component, &block) }

  around do |example|
    with_request_url("/frames", &example)
  end

  context "without block" do
    it do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component.to_html).to have_tag("div.card.border-primary") do
        with_tag("div.card-footer") do
          with_tag("input.btn.btn-primary.btn-sm", with: {
            type: :submit, form: :filters, value: "Filtrer",
          })
          with_tag("a.btn.btn-link.btn-sm.card-link", text: I18n.t("filter_component.reset", filters_count: nil))
          with_tag("small.ms-auto", text: I18n.t("filter_component.total", count: Frame.count))
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

    it do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component.to_html).to have_tag("div.card.border-primary") do
        with_tag("div.card-body") do
          with_tag("form#filters.row", with: { action: "", method: :get }) do
            with_tag("input", with: { type: :search, name: :q, value: "My" })
            with_tag("input", with: { type: :text, name: :u, value: "24" })
          end
        end

        with_tag("div.card-footer") do
          with_tag("a.btn.btn-link.btn-sm", text: I18n.t("filter_component.reset", filters_count: " (2)"), with: { href: "http://test.host/frames" })
          with_tag("small.ms-auto", text: I18n.t("filter_component.total_with_filters", total_count: Frame.count, results_count: 3))
        end
      end
    end
  end
end
