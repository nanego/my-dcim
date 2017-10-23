class Port < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked :parameters => {
      :server => proc { |controller, model_instance| model_instance.card.try(:server)},
      :card_type => proc { |controller, model_instance| "#{model_instance.card.try(:composant)} #{model_instance.card.try(:card_type)}"},
      :vlans => :vlans
  }

  belongs_to :card

  has_one :connection
  has_one :cable, through: :connection
  has_one :server, through: :card

  scope :sorted, -> {order(:position)}

  # Callbacks
  after_save :update_pdus_elements

  def network_conf(switch_slot)
    cable_name = connection.try(:cable).try(:name)
    if cable_name.present?
      "#{connection.cable.try(:color)} - #{cable_name} - Switch #{cable_name[0]} - Port #{switch_slot}:#{cable_name[1..-1]} - #{vlans}"
    end
  end

  def connect_to_port(other_port, cable_name, cable_color, vlans)
    remove_unused_connections(self, other_port)

    cable = nil
    if self.connection.present?
      cable ||= self.connection.cable
    end
    if other_port.connection.present?
      cable ||= other_port.connection.cable
    end
    if cable.present? and !cable.destroyed?
      cable.name = cable_name
      cable.color = cable_color
      cable.save
    else
      cable = Cable.create(name: cable_name, color: cable_color)
    end

    self.connection = Connection.find_or_create_by(port: self, cable: cable)
    other_port.connection = Connection.find_or_create_by(port: other_port, cable: cable)
    self.vlans = vlans
    other_port.vlans = self.vlans

    self.save && other_port.save
  end

  def cablename
    if connection.present? && connection.try(:cable).present? && connection.try(:cable).try(:name).present?
      connection.cable.name
    else
      ""
    end
  end

  def cablecolor
    self.try(:connection).try(:cable).present? ? self.connection.cable.color : ''
  end

  private

  def update_pdus_elements
    if card.present? &&  card.server.present? && card.server.frame.present?
      frame = card.server.frame
      if cablename =~ /L..../
        frame.pdu = Pdu.create(name: "PDU #{frame.to_s}") if frame.pdu.blank?
        frame.pdu.create_pdu_elements_by_cablename(cablename)
      end
    end
  end

  def remove_unused_connections(port1, port2)
    old_port1_destination = port1.connection.try(:paired_connection).try(:port)
    if old_port1_destination.present? && old_port1_destination != port2
      old_port1_destination.connection.cable.destroy
    end
    old_port2_destination = port2.connection.try(:paired_connection).try(:port)
    if old_port2_destination.present? && old_port2_destination != port1
      old_port2_destination.connection.cable.destroy
    end
  end

end
