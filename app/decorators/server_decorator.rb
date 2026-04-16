# frozen_string_literal: true

class ServerDecorator < ApplicationDecorator
  class << self
    def options_for_select(user)
      authorized_scope(Server.no_pdus.sorted, user:).map { |d| [d.name, d.id] }
    end

    def rooms_options_for_select(user)
      RoomDecorator.options_for_select(user)
    end

    def islets_options_for_select(user)
      IsletDecorator.options_for_select(user)
    end

    def bays_options_for_select(user)
      BayDecorator.options_for_select(user)
    end

    def frames_options_for_select(user)
      FrameDecorator.options_for_select(user)
    end

    def domains_options_for_select(user)
      DomaineDecorator.options_for_select(user)
    end

    def manufacturers_options_for_select
      ManufacturerDecorator.options_for_select
    end
  end

  def glpi_equipment(glpi_client: nil, params: nil)
    server_category = modele.category
    return nil if server_category.glpi_sync_type_none?

    glpi_client ||= GlpiClient.new
    glpi_external_app_record = external_app_records.find_by(app_name: ExternalAppRecord::GLPI_APP_NAME)
    glpi_id = glpi_external_app_record&.external_id

    if server_category.glpi_sync_type_server?
      glpi_client.computer(
        glpi_id: glpi_id || glpi_client.computer_glpi_id(serial: numero),
        params:,
      )
    else
      glpi_client.network_equipment(
        glpi_id: glpi_id || glpi_client.network_equipment_glpi_id(serial: numero),
        params:,
      )
    end
  end

  def network_types_to_human
    return Modele.human_attribute_name("network_types.blank") unless (n_t = network_types.presence)

    n_t.map { |type| Modele.human_attribute_name("network_types.#{type}") }.join(", ")
  end

  def full_name
    [modele&.category, name].compact.join(" ")
  end

  def full_location
    [site, islet.decorated.name_with_room].compact_blank.join(" - ")
  end

  def in_frame_location
    [frame, "U#{position || "?"}"].compact_blank.join(" - ")
  end
end
