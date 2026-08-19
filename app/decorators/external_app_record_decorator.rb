# frozen_string_literal: true

class ExternalAppRecordDecorator < ApplicationDecorator
  class << self
    def external_serial_status_options_for_select
      ExternalAppRecord::EXTERNAL_SERIAL_STATUSES.map do |s|
        [ExternalAppRecord.human_attribute_name("external_serial.#{s}"), s]
      end
    end
  end

  def external_serial_to_badge_component
    status = external_serial.present? ? :found : :not_found
    text = ExternalAppRecord.human_attribute_name("external_serial.#{status}").upcase
    color = status == :found ? :success : :danger

    BadgeComponent.new(text, color:, variant: :pill)
  end
end
