class AddCounterCaches < ActiveRecord::Migration[7.0]
  RESET_COUNTERS = {
    site: %i[rooms],
  }.freeze

  def change
    add_column :sites, :rooms_count, :integer, null: false, default: 0
    # add_column :categories, :modeles_count, :integer, null: false, default: 0

    up_only do
      say_with_time "Populate counters" do
        RESET_COUNTERS.each do |class_name, counters|
          klass = class_name.to_s.classify.constantize

          Site.find_each do |site|
            Site.reset_counters(site.id, *counters)
          end
        end
      end
    end
  end
end
