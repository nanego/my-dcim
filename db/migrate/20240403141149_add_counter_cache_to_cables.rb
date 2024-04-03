class AddCounterCacheToCables < ActiveRecord::Migration[7.1]
  RESET_COUNTERS = {
    cable: %i[connections]
  }.freeze

  def change
    add_column :cables, :connections_count, :integer, null: false, default: 0

    up_only do
      say_with_time "Populate counters" do
        RESET_COUNTERS.each do |class_name, counters|
          klass = class_name.to_s.classify.constantize

          klass.find_each do |site|
            klass.reset_counters(site.id, *counters)
          end
        end
      end
    end
  end
end
