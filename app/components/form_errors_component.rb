# frozen_string_literal: true

class FormErrorsComponent < ApplicationComponent
  erb_template <<~ERB
    <div class="alert alert-danger alert-dismissable" role="alert">
      <button type="button" class="close" data-dismiss="alert">
        <span aria-hidden="true">&times;</span>
        <span class="sr-only">Close</span>
      </button>

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
