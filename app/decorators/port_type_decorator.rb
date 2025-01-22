# frozen_string_literal: true

class PortTypeDecorator < ApplicationDecorator
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
