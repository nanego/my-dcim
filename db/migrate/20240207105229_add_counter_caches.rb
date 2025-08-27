# frozen_string_literal: true

class MigrationSite < ActiveRecord::Base
  self.table_name = :sites

  has_many :rooms, class_name: "MigrationRoom", foreign_key: :site_id
end

class MigrationCategory < ActiveRecord::Base
  self.table_name = :categories

  has_many :modeles, class_name: "MigrationModele", foreign_key: :category_id
end

class MigrationArchitecture < ActiveRecord::Base
  self.table_name = :architectures

  has_many :modeles, class_name: "MigrationModele", foreign_key: :architecture_id
end

class MigrationManufacturer < ActiveRecord::Base
  self.table_name = :manufacturers

  has_many :modeles, class_name: "MigrationModele", foreign_key: :manufacturer_id
end

class MigrationStack < ActiveRecord::Base
  self.table_name = :stacks

  has_many :servers, class_name: "MigrationServer", foreign_key: :stack_id
end

class MigrationPortType < ActiveRecord::Base
  self.table_name = :port_types

  has_many :card_types, class_name: "MigrationCardType", foreign_key: :port_type_id
end

class MigrationDomaine < ActiveRecord::Base
  self.table_name = :domaines

  has_many :servers, class_name: "MigrationServer", foreign_key: :domaine_id
end

class MigrationGestion < ActiveRecord::Base
  self.table_name = :gestions

  has_many :servers, class_name: "MigrationServer", foreign_key: :gestion_id
end

class MigrationCluster < ActiveRecord::Base
  self.table_name = :clusters

  has_many :servers, class_name: "MigrationServer", foreign_key: :cluster_id
end

class MigrationRoom < ActiveRecord::Base
  self.table_name = :rooms

  belongs_to :site, class_name: "MigrationSite", counter_cache: :rooms_count

  has_many :islets, class_name: "MigrationIslet", foreign_key: :room_id
end

class MigrationIslet < ActiveRecord::Base
  self.table_name = :islets

  belongs_to :room, class_name: "MigrationRoom", counter_cache: :islets_count
end

class MigrationServer < ActiveRecord::Base
  self.table_name = :servers

  belongs_to :gestion, class_name: "MigrationGestion", optional: true, counter_cache: :servers_count
  belongs_to :domaine, class_name: "MigrationDomaine", optional: true, counter_cache: :servers_count
  belongs_to :modele, class_name: "MigrationModele", counter_cache: :servers_count
  belongs_to :cluster, class_name: "MigrationCluster", optional: true, counter_cache: :servers_count
  belongs_to :stack, class_name: "MigrationStack", optional: true, counter_cache: :servers_count
end

class MigrationModele < ActiveRecord::Base
  self.table_name = :modeles

  belongs_to :manufacturer, class_name: "MigrationManufacturer", counter_cache: :modeles_count
  belongs_to :architecture, class_name: "MigrationArchitecture", counter_cache: :modeles_count
  belongs_to :category, class_name: "MigrationCategory", counter_cache: :modeles_count

  has_many :servers, class_name: "MigrationServer", foreign_key: :modele_id
end

class MigrationCardType < ActiveRecord::Base
  self.table_name = :card_types

  belongs_to :port_type, class_name: "MigrationPortType", counter_cache: :card_types_count
end

class AddCounterCaches < ActiveRecord::Migration[7.0]
  RESET_COUNTERS = {
    site: %i[rooms],
    room: %i[islets],
    modele: %i[servers],
    category: %i[modeles],
    architecture: %i[modeles],
    manufacturer: %i[modeles],
    stack: %i[servers],
    port_type: %i[card_types],
    domaine: %i[servers],
    gestion: %i[servers],
    cluster: %i[servers],
  }.freeze

  def change
    add_column :sites, :rooms_count, :integer, null: false, default: 0
    # add_column :rooms, :islets_count, :integer, null: false, default: 0 # NOTE: Already present
    add_column :modeles, :servers_count, :integer, null: false, default: 0
    add_column :categories, :modeles_count, :integer, null: false, default: 0
    add_column :architectures, :modeles_count, :integer, null: false, default: 0
    add_column :manufacturers, :modeles_count, :integer, null: false, default: 0
    add_column :stacks, :servers_count, :integer, null: false, default: 0
    add_column :port_types, :card_types_count, :integer, null: false, default: 0
    add_column :domaines, :servers_count, :integer, null: false, default: 0
    add_column :gestions, :servers_count, :integer, null: false, default: 0
    add_column :clusters, :servers_count, :integer, null: false, default: 0

    up_only do
      say_with_time "Populate counters" do
        RESET_COUNTERS.each do |class_name, counters|
          klass = "Migration#{class_name.to_s.classify}".constantize

          klass.find_each do |record|
            klass.reset_counters(record.id, *counters)
          end
        end
      end
    end
  end
end
