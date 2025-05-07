# frozen_string_literal: true

module List
  class DataTableComponent < ApplicationComponent
    renders_many :bulk_actions, ->(*args, **kwargs) { DatatableBulkAction.new(*args, **kwargs) }
    renders_many :columns, lambda { |title = nil, **options, &block|
      DatatableColumn.new(title, **options, &block)
    }

    def initialize(data, columns_to_display: nil, empty_icon: :table, **_options)
      @data = data
      @empty_icon = empty_icon
      @columns_to_display = columns_to_display&.map(&:to_sym)

      super()
    end

    def call
      if @data.empty?
        render CardComponent.new(extra_classes: "text-center text-secondary-emphasis") do
          concat(tag.i(class: "bi bi-#{@empty_icon} fs-1 text-secondary text-opacity-25"))
          concat(tag.h5(t(".empty_table.title"), class: "card-title mt-3"))
        end
      else
        bulk_actions_wrapper do
          render List::TableComponent.new do |table|
            table.with_head do
              render List::TableComponent::TableRow.new do
                concat(render_bulk_head_checkbox) if bulk_actions?

                displayed_columns.each do |col|
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
    end

    private

    def bulk_actions_wrapper
      return yield unless bulk_actions?

      tag.div data: { controller: "bulk-actions" } do
        concat(tag.div(style: "display: none;", data: { bulk_actions_target: "actionsContainer" }) do
          concat(render(CardComponent.new(extra_classes: "mb-4")) do
            concat(tag.div(class: "d-flex justify-content-between align-items-center") do
              concat(tag.span do
                concat(tag.span(class: "fw-bolder", data: { bulk_actions_target: "checkedCount" }))
                concat(tag.span(" #{t(".bulk.selected_elements")}"))
              end)

              bulk_actions.each do |bulk_action|
                concat(bulk_action)
              end
            end)
          end)
        end)

        concat(yield)
      end
    end

    def render_bulk_head_checkbox
      render(List::TableComponent::TableHeadCell.new(style: "width: 0;")) do
        tag.input class: "form-check-input", type: :checkbox, data: { bulk_actions_target: "checkboxAll" }
      end
    end

    def render_head_cell(col)
      render(List::TableComponent::TableHeadCell.new(data: { name: col.name })) do
        if (sort_by = col.sort_by)
          link_to_sort col.title, sort_by
        else
          col.title
        end
      end
    end

    def render_row(row)
      render List::TableComponent::TableRow.new do
        concat(render_bulk_checkbox(row)) if bulk_actions?

        displayed_columns.each do |col|
          concat render List::TableComponent::TableCell.new(render_col(col, row), **col.html_options)
        end
      end
    end

    def render_bulk_checkbox(row)
      render List::TableComponent::TableCell.new do
        check_box_tag "ids[]", row.id, class: "form-check-input", value: row.id, data: { bulk_actions_target: "checkbox" }
      end
    end

    def render_col(col, row)
      col.call(row)
    end

    def link_to_sort(label, attribute)
      current_attribute = params[:sort_by]&.to_sym
      current_direction = current_attribute == attribute ? params[:sort].to_sym : nil

      parameters = case current_direction
                   when nil then { sort_by: attribute, sort: :asc }
                   when :asc then { sort_by: attribute, sort: :desc }
                   else { sort_by: nil, sort: nil }
                   end

      url = url_for(controller.request.query_parameters.merge(parameters))

      link_to(url) do
        concat label
        concat " #{sort_caret(current_direction)}" if current_attribute == attribute
      end
    end

    def sort_caret(direction)
      sanitize(direction == :desc ? "&#x2193;" : "&#x2191;")
    end

    def displayed_columns
      @displayed_columns ||= if @columns_to_display.nil?
                          columns
                        else
                          columns.select do |col|
                            col.name.nil? || @columns_to_display.include?(col.name)
                          end
                        end
    end

    class DatatableBulkAction < ApplicationComponent
      attr_reader :title, :url, :method, :options

      def initialize(title = nil, url:, method:, **options)
        @title = title
        @options = options
        confirm = @options[:data].delete(:confirm) || @options[:data].delete(:turbo_confirm)

        data = {
          bulk_actions_method_param: method || :post,
          bulk_actions_url_param: url,
          bulk_actions_confirm_param: confirm,
          action: "bulk-actions#submit"
        }
        @options[:data] = data.merge(options[:data]) do |key, a, b|
          case key
          when :action
            class_names(a, b)
          else
            b
          end
        end

        super()
      end

      def call
        tag.button(type: :button, **@options) { @title || content }
      end
    end

    class DatatableColumn < ApplicationComponent
      attr_reader :title, :name, :sort_by, :html_options

      def initialize(title = nil, **options, &block)
        @title = title
        @name = options.delete(:name)
        @sort_by = options.delete(:sort_by)
        @html_options = options
        @block = block

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
