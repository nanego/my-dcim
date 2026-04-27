# frozen_string_literal: true

class DomainDecorator < ApplicationDecorator
  class << self
    def options_for_select(user)
      authorized_scope(Domain.sorted, user:).map { |d| [d.name, d.id] }
    end
  end
end
