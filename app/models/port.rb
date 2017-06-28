class Port < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked :parameters => {
      :server => proc { |controller, model_instance| model_instance.cards_server.try(:server)},
      :carte => proc { |controller, model_instance| "#{model_instance.cards_server.try(:composant)} #{model_instance.cards_server.try(:card)}"},
      :vlans => :vlans,
      :color => :color,
      :cablename => :cablename
  }

  belongs_to :cards_server

  # Callbacks
  after_save :update_pdus_elements

  def network_conf(switch_slot)
    if cablename.present?
      "#{color} - #{cablename} - Switch #{cablename[0]} - Port #{switch_slot}:#{cablename[1..-1]} - #{vlans}"
    end
  end

  private

  def update_pdus_elements
    if cards_server.present? &&  cards_server.server.present? && cards_server.server.frame.present?
      frame = cards_server.server.frame
      if cablename =~ /L..../
        frame.pdu = Pdu.create(name: "PDU #{frame.to_s}") if frame.pdu.blank?
        frame.pdu.create_pdu_elements_by_cablename(cablename)
      end
    end
  end

end
