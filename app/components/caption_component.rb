# frozen_string_literal: true

class CaptionComponent < ApplicationComponent
  erb_template <<~ERB
    <span class="caption-component">
      <span class="caption-component-button glyphicon glyphicon-info-sign" aria-hidden="true"></span>
      <span class="caption-component-content"><%= content %></span>
    </span>
  ERB
end
