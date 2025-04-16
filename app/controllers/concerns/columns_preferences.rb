# frozen_string_literal: true

module ColumnsPreferences
  extend ActiveSupport::Concern

  class_methods do
    attr_reader :__model

    def has_preferred_columns(model) # rubocop:disable Naming/PredicateName
      @__model = model
    end
  end

  included do
    before_action :columns_action, only: :index # rubocop:disable Rails/LexicallyScopedActionFilter

    def columns_action
      if params[:reset].present?
        session[self.class.__model] = nil
      elsif params[:save].present?
        session[self.class.__model] = params[:columns]
      end
    end
  end
end
