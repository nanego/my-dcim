# frozen_string_literal: true

class PortTypeDecorator < ApplicationDecorator
  def self.options_for_select(collection = PortType)
    collection.select(:id, :name).sorted.map { |p| [p.to_s, p.id] }
  end

  def self.usable_by_options_for_select
    PortType::USABLE_BY_VALUES.map do |value|
      [I18n.t(".activerecord.attributes.port_type.usable_by/#{value}"), value]
    end
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
