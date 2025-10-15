# frozen_string_literal: true

class DomaineDecorator < ApplicationDecorator
  class << self
    def options_for_select(user)
      authorized_scope(Domaine.sorted, user:).map { |d| [d.name, d.id] }
    end
  end
end
