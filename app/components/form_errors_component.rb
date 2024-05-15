# frozen_string_literal: true

class FormErrorsComponent < ApplicationComponent
  erb_template <<~ERB
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>

      <h4><%= t(".title", count: @object.errors.count) %></h4>

      <ul>
        <% @object.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>
        <% end %>
      </ul>
    </div>
  ERB

  def initialize(object)
    @object = object

    super()
  end

  def render?
    @object&.errors&.any?
  end
end
