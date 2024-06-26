# frozen_string_literal: true

class FilterComponent < ApplicationComponent
  renders_one :form, ->(&block) { FilterComponent::Form.new(&block) }

  erb_template <<~ERB
    <%= render CardComponent.new(type: :primary) do |card| %>
      <%#= filters_badge_tags %>

      <%= form_with model: @filter, url: "", method: :get, class: "row row-cols-lg-auto g-3 align-items-center", id: :filters do |f| %>
        <%= form&.call(f) %>

        <% card.with_footer do %>
          <%= f.submit t(".submit"), class: "btn btn-primary btn-sm", form: :filters %>
          <%= link_to t(".reset", filters_count: counter_tag),
                      url_for(only_path: false, overwrite_params: nil),
                      class: "btn btn-link card-link btn-sm" %>

          <%= totals_tag %>
        <% end %>
      <% end %>
    <% end %>
  ERB

  def initialize(filter)
    @filter = filter

    super()
  end

  def filters_badge_tags
    tag.div do
      @filter.filled_attributes.each do |filter, value|
        concat filter_badge_tag(filter, value)
      end
    end
  end

  def filter_badge_tag(filter, value)
    params = request.query_parameters.dup
    params.delete(filter)
    url = url_for(params)

    tag.span class: "label label-info" do
      concat "#{Filter.human_attribute_name(filter, throw: true, raise: true)}: #{value} "
      concat(link_to(url) do
        tag.span class: "glyphicon glyphicon-remove", aria_hidden: true
      end)
    end
  end

  def counter_tag
    return unless @filter.filled?

    " (#{@filter.filled_attributes.size})"
  end

  def totals_tag
    tag.small class: "ms-auto text-secondary-emphasis" do
      if @filter.filled?
        t(".total_with_filters", results_count: @filter.results_count, total_count: @filter.total_count)
      else
        t(".total", count: @filter.total_count)
      end
    end
  end

  class Form < ApplicationComponent
    delegate :call, to: :@block

    def initialize(&block)
      @block = block

      super()
    end
  end
end
