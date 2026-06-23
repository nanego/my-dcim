# frozen_string_literal: true

class PortTypeDecorator < ApplicationDecorator
  def self.options_for_select
    PortType.select(:id, :name).sorted.map { |p| [p.to_s, p.id] }
  end

  def css_class_name
    case name
    when "RJ", "XRJ"
      "portRJ"
    when "FC", "SC"
      "portFC"
    when "ALIM"
      "portALIM"
    else
      "portSCSI"
    end
  end
end
