# frozen_string_literal: true

module DeleteDependency
  class DefaultsComponent < ApplicationComponent
    erb_template <<~ERB
      <h4 class="mt-5"><%= @model.model_name.human %></h4>
      <ul class="list-group" style="width: 18rem;">
        <% @records.each do |record| %>
          <li class="list-group-item">
            <%= show_link record %>
          </li>
        <% end %>
      </ul>
    ERB

    def initialize(model, records)
      @model = model
      @records = records
      super
    end

    private

    def show_link(record)
      link_to record.to_s, url_for(record), target: "_blank", rel: "noopener"
    rescue StandardError
      "<p>#{record}<p/>"
    end
  end
end
