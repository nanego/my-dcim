# frozen_string_literal: true

class CableDecorator < ApplicationDecorator
  include ActionView::Helpers::AssetTagHelper
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Context

  class << self
    def servers_options_for_select(user)
      ServerDecorator.options_for_select(user)
    end

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

  def server_connected_with_link(connection, from: false)
    tag.span class: class_names("text-body-emphasis col overflow-wrap", "text-end": from) do
      if (server = connection&.server)
        link_to server.to_s,
                server_path(server),
                class: "text-body-emphasis",
                data: { turbo_frame: :_top }
      else
        tag.span "n/c", class: "fst-italic fw-light text-body-secondary"
      end
    end
  end

  def draw_port(connection)
    if (twin_card_id = connection&.card&.twin_card_id)
      twin_card = Card.find(twin_card_id)
      twin_connections = twin_card.ports.map(&:connection)
      twin_card_used_ports = []
      twin_connections.each { |c| twin_card_used_ports << c.port.position if c&.port }
    end

    if (port = connection&.port)
      card_type = connection&.card&.card_type
      port_type = card_type&.port_type
      port_type_class = port_type&.decorated&.css_class_name

      span_text = name.presence || "n/c"

      tag.span span_text,
               class: class_names(
                 "me-0 port #{color} text-body-emphasis #{port_type_class}",
                 "fst-italic fw-light text-body-secondary": name.blank?,
                 no_client: port && port.cable_name && twin_card_used_ports&.exclude?(port.position),
               )
    else
      tag.span "n/c", class: "badge empty me-0 border text-body-emphasis fst-italic fw-light text-body-secondary"
    end
  end

  def description
    port_from = ports.first
    port_to = ports.second

    Cable.human_attribute_name(:description,
                               from_server_category: port_from.server.try(:modele).try(:category),
                               from_server: port_from.server,
                               from_port_id: port_from.id,
                               to_server_category: port_to.try(:server).try(:modele).try(:category),
                               to_server: port_to.try(:server),
                               to_port_id: port_to.try(:id),
                               vlans: port_from.vlans,
                               cablename: port_from.cable_name,
                               color: port_from.color)
  end
  alias to_s description

  def display_name
    "#{name.presence || (Cable.model_name.human + "##{id}")} (#{color.presence || "n/c"})"
  end
end
