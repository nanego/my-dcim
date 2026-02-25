# frozen_string_literal: true

module List
  class DataTableComponent < ApplicationComponent # rubocop:disable Metrics/ClassLength
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
        render CardEmptyDataComponent.new(icon: @empty_icon)
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
        concat col.title

        if (sort_by = col.sort_by)
          links_to_sort sort_by
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

    def links_to_sort(attribute)
      current_attribute = params[:sort_by]&.to_sym
      is_current_attribute = current_attribute == attribute
      current_direction = is_current_attribute ? params[:sort].to_sym : nil

      concat(link_to_sort(attribute, is_current_attribute, :asc, current_direction))
      concat(link_to_sort(attribute, is_current_attribute, :desc, current_direction))
    end

    def link_to_sort(attribute, is_current_attribute, direction, current_direction)
      caret = direction == :asc ? "arrow-up-short" : "arrow-down-short"
      is_current_direction = current_direction == direction

      parameters = is_current_direction ? { sort_by: nil, sort: nil } : { sort_by: attribute, sort: direction }
      url = url_for(controller.request.query_parameters.merge(parameters))

      link_to(url) do
        # TODO: user tooltip ?
        concat tag.span class: class_names("bi bi-#{caret}",
                                           "ms-2": direction == :asc,
                                           "link-primary": is_current_direction && is_current_attribute),
                        title: direction,
                        data: { controller: "tooltip" }
      end
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
          action: "bulk-actions#submit",
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

      delegate :call, to: :@block

      def block?
        @block.present?
      end
    end
  end
end
