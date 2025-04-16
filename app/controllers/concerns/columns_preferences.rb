# frozen_string_literal: true

module ColumnsPreferences
  extend ActiveSupport::Concern

  Columns = Data.define(:default, :available, :preferred)

  class_methods do
    def columns_preferences_with(default:, available:, key: controller_name, only: :index)
      before_action(only:) do
        if params[:reset]
          session[key] = nil
        elsif params[:save]
          session[key] = params[:columns]
        end

        @columns_preferences = Columns.new(
          default:,
          available:,
          preferred: params[:columns] || session[key] || default
        )
      end
    end
  end
end
