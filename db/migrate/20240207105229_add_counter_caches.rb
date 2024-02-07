class AddCounterCaches < ActiveRecord::Migration[7.0]
  RESET_COUNTERS = {
    site: %i[rooms],
    room: %i[islets],
    # bay: %i[servers],
    stack: %i[servers],
    port_type: %i[card_types],
    domaine: %i[servers],
    gestion: %i[servers],
    cluster: %i[servers],
  }.freeze

  def change
    add_column :sites, :rooms_count, :integer, null: false, default: 0
    # add_column :rooms, :islets_count, :integer, null: false, default: 0
    # add_column :bays, :servers_count, :integer, null: false, default: 0
    # add_column :categories, :modeles_count, :integer, null: false, default: 0
    add_column :stacks, :servers_count, :integer, null: false, default: 0
    add_column :port_types, :card_types_count, :integer, null: false, default: 0
    add_column :domaines, :servers_count, :integer, null: false, default: 0
    add_column :gestions, :servers_count, :integer, null: false, default: 0
    add_column :clusters, :servers_count, :integer, null: false, default: 0

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
