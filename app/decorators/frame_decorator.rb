# frozen_string_literal: true

class FrameDecorator < ApplicationDecorator
  class << self
    def options_for_select(user)
      authorized_scope(Frame.sorted, user:).map { |f| [f.name, f.id] }
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

    def access_control_options_for_select
      Bay.access_controls.keys.map { |a_c| [I18n.t("access_control.#{a_c}"), a_c] }
    end
  end
end
