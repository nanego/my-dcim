class Port < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked :parameters => {
      :server => proc { |controller, model_instance| model_instance.parent.try(:server)},
      :carte => proc { |controller, model_instance| "#{model_instance.parent.try(:composant)} #{model_instance.parent.try(:card)}"},
      :vlans => :vlans,
      :color => :color,
      :cablename => :cablename
  }

  belongs_to :parent, :polymorphic => true

  # Callbacks
  after_save :update_pdus_elements

  def network_conf(switch_slot)
    if cablename.present?
      "#{color} - #{cablename} - Switch #{cablename[0]} - Port #{switch_slot}:#{cablename[1..-1]} - #{vlans}"
    end
  end

  private

  def update_pdus_elements
    if parent.server.present? && parent.server.frame.present?
      frame = parent.server.frame
      if cablename =~ /L..../
        frame.pdu = Pdu.create(name: "PDU #{frame.to_s}") if frame.pdu.blank?
        frame.pdu.create_pdu_elements_by_cablename(cablename)
      end
    end
  end

end
