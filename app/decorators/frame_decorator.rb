# frozen_string_literal: true

class FrameDecorator < ApplicationDecorator
  class << self
    def for_options(user)
      authorized_scope(Frame.sorted, user:).map { |f| [f.name, f.id] }
    end

    def rooms_for_options(user)
      RoomDecorator.for_options(user)
    end

    def islets_for_options(user)
      IsletDecorator.for_options(user)
    end

    def bays_for_options(user)
      BayDecorator.for_options(user)
    end

    def access_control_options_for_select
      Bay.access_controls.keys.map { |a_c| [I18n.t("access_control.#{a_c}"), a_c] }
    end
  end
end
