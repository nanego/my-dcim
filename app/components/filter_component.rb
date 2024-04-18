# frozen_string_literal: true

# TODO: use CardComponent
class FilterComponent < ApplicationComponent
  renders_one :form, ->(&block) { FilterComponent::Form.new(&block) }

  erb_template <<~ERB
    <%= render CardComponent.new(type: :primary) do |card| %>
      <% card.with_header do %>
        <h3 class="panel-title">Filtres<%= counter_tag %></h3>
      <% end %>

      <%= filters_badge_tags %>

      <%= form_with model: @filter, url: "", method: :get, class: "form-inline", id: :filters do |f| %>
        <div class="panel-body">
          <%= form.call(f) %>
        </div>

        <% card.with_footer do %>
          <%= f.submit "Filtrer", class: "btn btn-primary btn-sm", form: :filters %>
          <%= link_to "Reset", url_for(only_path: false, overwrite_params: nil), class: "btn btn-secondary btn-sm" %>

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
        concat tag.span "#{Filter.human_attribute_name(filter, throw: true, raise: true)}: #{value}", class: "badge"
      end
    end
  end

  def counter_tag
    return unless @filter.filled?

    " (#{@filter.filled_attributes.size})"
  end

  def totals_tag
    tag.span class: "pull-right" do
      if @filter.filled?
        "Total: #{@filter.results_count} of #{@filter.total_count}"
      else
        "Total: #{@filter.total_count}"
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
