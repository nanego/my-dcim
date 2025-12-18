# frozen_string_literal: true

class ApplicationDecorator < Dekorator::Base
  class << self
    def authorized_scope(relation, user:)
      klass = "#{name.sub("Decorator", "")}Policy".constantize
      klass.new(user:).apply_scope(relation, type: :active_record_relation)
    end
  end

  def display_name
    to_s
  end
end
