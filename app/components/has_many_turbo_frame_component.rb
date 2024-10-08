# frozen_string_literal: true

class HasManyTurboFrameComponent < ApplicationComponent
  include Turbo::FramesHelper

  erb_template <<~ERB
    <%= render CardComponent.new(type: :primary, extra_classes: "bg-body-tertiary mt-4") do |c| %>
      <% c.with_header do %>
        <div class="d-flex justify-content-between">
          <span><%= @title %></span>

          <%= link_to @url do %>
            <%= t(".see_more_filters") %>
          <% end %>
        </div>
      <% end %>

      <%= turbo_frame_tag(@frame_id, loading: :lazy, src: @url) do %>
        <div class="w-100 d-flex justify-content-center align-items-center gap-3">
          <span><%= t(".loading") %></span>
          <span class="spinner-border spinner-border-sm p-4"></span>
        </div>
      <% end %>
    <% end %>
  ERB

  def initialize(title, url:, frame_id:)
    @title = title
    @url = url
    @frame_id = frame_id

    super()
  end
end
