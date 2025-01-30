# frozen_string_literal: true

require "rails_helper"

RSpec.describe List::TableComponent, type: :component do
  let(:component) { described_class.new }
  let(:rendered_component) { render_inline(component, &block).to_html }
  let(:cell) do
    render_inline(List::TableComponent::TableCell.new("John")).to_html.html_safe # rubocop:disable Rails/OutputSafety
  end

  let(:block) do
    proc do |table|
      table.with_head do
        render_inline(List::TableComponent::TableRow.new) do
          render_inline(List::TableComponent::TableHeadCell.new("Name")).to_html.html_safe # rubocop:disable Rails/OutputSafety
        end.to_html.html_safe # rubocop:disable Rails/OutputSafety
      end
      table.with_body do
        render_inline(List::TableComponent::TableRow.new) do
          cell
        end.to_html.html_safe # rubocop:disable Rails/OutputSafety
      end
    end
  end

  it do # rubocop:disable RSpec/ExampleLength
    expect(rendered_component).to have_tag("div.table-responsive") do
      with_tag("table.table") do
        with_tag("thead") do
          with_tag("tr") do
            with_tag("th", text: "Name")
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

  describe "tests on vertical alignment options" do
    context "with no argument given" do
      it do # rubocop:disable RSpec/ExampleLength
        expect(rendered_component).to have_tag("div.table-responsive") do
          with_tag("table.table") do
            with_tag("tbody") do
              with_tag("tr") do
                with_tag("td.align-middle", text: "John")
              end
            end
          end
        end
      end
    end

    context "with an argument given" do
      let(:cell) do
        render_inline(List::TableComponent::TableCell.new("John", v_align: :baseline)).to_html.html_safe # rubocop:disable Rails/OutputSafety
      end

      it do # rubocop:disable RSpec/ExampleLength
        expect(rendered_component).to have_tag("div.table-responsive") do
          with_tag("table.table") do
            with_tag("tbody") do
              with_tag("tr") do
                with_tag("td.align-baseline", text: "John")
              end
            end
          end
        end
      end
    end

    context "with a wrong argument given" do
      let(:cell) do
        render_inline(List::TableComponent::TableCell.new("John", v_align: :wrong)).to_html.html_safe # rubocop:disable Rails/OutputSafety
      end

      it do # rubocop:disable RSpec/ExampleLength
        expect(rendered_component).to have_tag("div.table-responsive") do
          with_tag("table.table") do
            with_tag("tbody") do
              with_tag("tr") do
                without_tag("td.align-middle", text: "John")
                with_tag("td", text: "John")
              end
            end
          end
        end
      end
    end
  end

  describe "tests on text alignment options" do
    context "with no argument given" do
      it do # rubocop:disable RSpec/ExampleLength
        expect(rendered_component).to have_tag("div.table-responsive") do
          with_tag("table.table") do
            with_tag("tbody") do
              with_tag("tr") do
                with_tag("td.text-start", text: "John")
              end
            end
          end
        end
      end
    end

    context "with an argument given" do
      let(:cell) do
        render_inline(List::TableComponent::TableCell.new("John", text_align: :center)).to_html.html_safe # rubocop:disable Rails/OutputSafety
      end

      it do # rubocop:disable RSpec/ExampleLength
        expect(rendered_component).to have_tag("div.table-responsive") do
          with_tag("table.table") do
            with_tag("tbody") do
              with_tag("tr") do
                with_tag("td.text-center", text: "John")
              end
            end
          end
        end
      end
    end

    context "with a wrong argument given" do
      let(:cell) do
        render_inline(List::TableComponent::TableCell.new("John", text_align: :wrong)).to_html.html_safe # rubocop:disable Rails/OutputSafety
      end

      it do # rubocop:disable RSpec/ExampleLength
        expect(rendered_component).to have_tag("div.table-responsive") do
          with_tag("table.table") do
            with_tag("tbody") do
              with_tag("tr") do
                without_tag("td.text-start", text: "John")
                with_tag("td", text: "John")
              end
            end
          end
        end
      end
    end
  end
end
