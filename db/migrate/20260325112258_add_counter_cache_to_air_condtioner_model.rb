# frozen_string_literal: true

class AddCounterCacheToAirCondtionerModel < ActiveRecord::Migration[8.0]
  class MigrationAirConditionerModel < ActiveRecord::Base
    self.table_name = :air_conditioner_models

    has_many :air_conditioners, class_name: "MigrationAirConditioner", foreign_key: :air_conditioner_model_id
  end

  class MigrationAirConditioner < ActiveRecord::Base
    self.table_name = :air_conditioners

    belongs_to :air_conditioner_model, class_name: "MigrationAirConditionerModel", counter_cache: :air_conditioners_count
  end

  def change
    add_column :air_conditioner_models, :air_conditioners_count, :integer, null: false, default: 0

    up_only do
      say_with_time "Populate Air Conditioner Model counter" do
        MigrationAirConditionerModel.find_each do |record|
          MigrationAirConditionerModel.reset_counters(record.id, :air_conditioners)
        end
      end
    end
  end
end
