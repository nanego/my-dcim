# frozen_string_literal: true

class ExternalAppRecordDecorator < ApplicationDecorator
  class << self
    def external_serial_status_options_for_select
      ExternalAppRecord::EXTERNAL_SERIAL_STATUSES.map do |s|
        [I18n.t(".activerecord.attributes.external_app_record.external_serials.#{s}"), s]
      end
    end
  end

  def external_serial_to_badge_component
    status = external_serial.present? ? :found : :not_found
    text = I18n.t(".activerecord.attributes.external_app_record.external_serials.#{status}").upcase
    color = status == :found ? :success : :danger

    BadgeComponent.new(text, color:)
  end
end
