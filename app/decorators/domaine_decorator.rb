# frozen_string_literal: true

class DomaineDecorator < ApplicationDecorator
  class << self
    def for_options(user)
      authorized_scope(Domaine.sorted, user:).map { |d| [d.name, d.id] }
    end
  end
end
