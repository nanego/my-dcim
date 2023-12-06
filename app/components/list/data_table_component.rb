# frozen_string_literal: true

module List
  class DataTableComponent < ApplicationComponent
    renders_many :columns, lambda { |title = nil, **options, &block|
      DatatableColumn.new(title, **options, &block)
    }

    def initialize(data, **options)
      @data = data

      super()
    end

    def call
      render List::TableComponent.new do |table|
        table.with_head do
          render List::TableComponent::TableRow.new do
            columns.each do |col|
              concat(render_head_cell(col))
            end
          end
        end

        table.with_body do
          @data.each do |data_row|
            concat(render_row(data_row))
          end
        end
      end
    end

    private

    def render_head_cell(col)
      render(List::TableComponent::TableHeadCell.new) do
        if (sort_by = col.options[:sort_by])
          link_to_sort col.title, sort_by
        else
          col.title
        end
      end
    end

    def render_row(row)
      render List::TableComponent::TableRow.new do
        columns.each do |col|
          concat render List::TableComponent::TableCell.new(render_col(col, row), class: col.options[:class])
        end
      end
    end

    def render_col(col, row)
      col.call(row)
    end

    private

    def link_to_sort(label, attribute)
      direction = params[:direction] == 'asc' ? 'desc' : 'asc'
      url = url_for(controller.request.query_parameters.merge(column: attribute, direction: direction))

      link_to(url) do
        concat label
        concat " #{sort_caret(direction)}" if params[:column] == attribute&.to_s
      end
    end

    def sort_caret(direction)
      sanitize(direction == 'desc' ? "&#9660;" : "&#9650;")
    end


    class DatatableColumn < ApplicationComponent
      attr_reader :title, :options

      def initialize(title = nil, **options, &block)
        @title = title
        @block = block
        @options = options

        super()
      end

      def call(row)
        @block.call(row)
      end

      def block?
        @block.present?
      end
    end
  end
end
