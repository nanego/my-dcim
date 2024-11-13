# frozen_string_literal: true

class HasManyTurboFrameComponent < ApplicationComponent
  include Turbo::FramesHelper

  erb_template <<~ERB
    <%= render CardComponent.new(type: :primary, extra_classes: @extra_classes, **@html_options) do |c| %>
      <% c.with_header do %>
        <div class="d-flex justify-content-between">
          <span><%= @title %></span>

          <%= link_to @url, class:"link-light" do %>
            <%= t(".see_more_filters") %>
          <% end %>
        </div>
      <% end %>

      <%= turbo_frame_tag(@frame_id, loading: :lazy, src: @url) do %>
        <div class="w-100 d-flex justify-content-center align-items-center gap-3">
          <span role="status"><%= t(".loading") %></span>
          <span class="spinner-grow text-primary" aria-hidden="true"></span>
        </div>
      <% end %>
    <% end %>
  ERB

  def initialize(title, url:, frame_id:, type: :tertiary, **html_options)
    @title = title
    @url = url
    @frame_id = frame_id
    @extra_classes = class_names("mt-4", "bg-body-#{type}")
    @html_options = html_options

    super()
  end
end
