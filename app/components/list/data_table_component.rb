# frozen_string_literal: true

module List
  class DataTableComponent < ApplicationComponent
    renders_many :columns, lambda { |title = nil, **options, &block|
      DatatableColumn.new(title, **options, &block)
    }

    def initialize(data, empty_icon: :table, **_options)
      @data = data
      @empty_icon = empty_icon

      super()
    end

    def call
      if @data.empty?
        render CardComponent.new(extra_classes: "text-center text-secondary-emphasis") do |card|
          concat(tag.i(class: "bi bi-#{@empty_icon} fs-1 text-secondary text-opacity-25"))
          concat(tag.h5(t(".empty_table.title"), class: "card-title mt-3"))
        end
      else
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
    end

    private

    def render_head_cell(col)
      render(List::TableComponent::TableHeadCell.new) do
        concat col.title

        if (sort_by = col.sort_by)
          links_to_sort sort_by
        end
      end
    end

    def render_row(row)
      render List::TableComponent::TableRow.new do
        columns.each do |col|
          concat render List::TableComponent::TableCell.new(render_col(col, row), **col.html_options)
        end
      end
    end

    def render_col(col, row)
      col.call(row)
    end

    def links_to_sort(attribute)
      current_attribute = params[:sort_by]&.to_sym
      is_current_attribute = current_attribute == attribute
      current_direction = is_current_attribute ? params[:sort].to_sym : nil

      concat(link_to_sort(attribute, is_current_attribute, :asc, current_direction))
      concat(link_to_sort(attribute, is_current_attribute, :desc, current_direction))
    end

    def link_to_sort(attribute, is_current_attribute, direction, current_direction)
      caret = direction == :asc ? "caret-up" : "caret-down"
      is_current_direction = current_direction == direction

      parameters = is_current_direction ? { sort_by: nil, sort: nil } : { sort_by: attribute, sort: direction }
      url = url_for(controller.request.query_parameters.merge(parameters))

      link_to(url) do
        concat tag.i class: class_names("bi bi-#{caret}",
                                        "ms-2": direction == :asc,
                                        active: is_current_direction && is_current_attribute)
      end
    end

    class DatatableColumn < ApplicationComponent
      attr_reader :title, :sort_by, :html_options

      def initialize(title = nil, **options, &block)
        @title = title
        @block = block
        @sort_by = options.delete(:sort_by)
        @html_options = options

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
