# frozen_string_literal: true

class ExternalAppRecordDecorator < ApplicationDecorator
  def external_serial_to_badge_component
    type = external_serial.present? ? :success : :danger
    text = I18n.t(".activerecord.attributes.external_app_record.external_serial.#{type}")

    LabelComponent.new(text, type:)
  end
end
