# frozen_string_literal: true

class CaptionComponent < ApplicationComponent
  erb_template <<~ERB
    <span class="caption-component">
      <span class="caption-component-button bi bi-info-circle" aria-hidden="true"></span>
      <span class="caption-component-content"><%= content %></span>
    </span>
  ERB
end
