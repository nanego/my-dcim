# frozen_string_literal: true

class CableDecorator < ApplicationDecorator
  include ActionView::Helpers::AssetTagHelper
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Context

  def servers
    @servers ||= begin
      from_connection = connections.first
      to_connection = connections.second

      tag.span class: "d-flex column-gap-1 text-secondary" do
        concat(server_link(from_connection))
        concat(tag.i class: "bi bi-dash-lg")
        concat(server_link(to_connection))
      end
    end
  end

  private

  def server_link(connection)
    if server = connection&.server
      link_to server.to_s,
              server_path(server),
              class: "badge text-bg-secondary",
              title: connection.card.decorated.full_name,
              data: { controller: "tooltip", "bs-placement": "bottom" },
              aria: { hidden: "true" }
    else
      tag.span "n/c", class: "fst-italic fw-lighter"
    end
  end
end
