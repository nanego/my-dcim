# frozen_string_literal: true

class CableDecorator < ApplicationDecorator
  include ActionView::Helpers::AssetTagHelper
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Context

  class << self
    def special_case_options_for_select
      [true, false].map do |s|
        [I18n.t("boolean.#{s}"), s]
      end
    end

    def colors_options_for_select
      Cable::COLORS.map do |k, v|
        [I18n.t(".activerecord.attributes.cable/color.#{v}"), k]
      end
    end
  end

  def connected_servers
    @connected_servers ||= begin
      from_connection = connections.first
      to_connection = connections.second

      tag.span class: "cable-index-servers d-flex column-gap-2 align-items-center justify-content-center" do
        concat(server_with_link(from_connection))
        concat(tag.span(class: "d-inline-flex align-items-center") do
          concat(draw_connection(from_connection))
          concat(tag.hr(class: "cable border #{color} border-t px-3 opacity-100"))
          concat(draw_connection(to_connection))
        end)
        concat(server_with_link(to_connection))
      end
    end
  end

  private

  def server_with_link(connection)
    if (server = connection&.server)
      link_to server.to_s,
              server_path(server),
              class: "text-body-emphasis",
              title: connection.card.decorated.full_name,
              data: { controller: "tooltip", 'bs-placement': "bottom", turbo_frame: :_top },
              aria: { hidden: "true" }
    else
      tag.span "n/c", class: "fst-italic fw-lighter"
    end
  end

  def draw_connection(connection)
    if (twin_card_id = connection&.card&.twin_card_id)
      twin_card = Card.find(twin_card_id)
      twin_connections = twin_card.ports.map(&:connection)
      twin_card_used_ports = []
      twin_connections.each { |c| twin_card_used_ports << c.port.position if c&.port }

      port_data = connection.port
    end

    if name.present?
      tag.span name,
               class: class_names("badge me-0 #{color} text-body-emphasis",
                                  'fst-italic fw-lighter': name.blank?,
                                  no_client: twin_card_used_ports && port_data && port_data.cable_name && twin_card_used_ports.exclude?(port_data.position)),
               data: { controller: "tooltip", 'bs-placement': "bottom" },
               title: connection&.port&.vlans,
               aria: { hidden: "true" }
    else
      tag.span "n/c", class: "badge empty me-0 border text-body-emphasis fst-italic fw-lighter"
    end
  end
end
