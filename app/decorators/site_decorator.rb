# frozen_string_literal: true

class SiteDecorator < ApplicationDecorator
  class << self
    def options_for_select(user)
      authorized_scope(Site.sorted, user:).map { |s| [s.name, s.id] }
    end
  end
end
