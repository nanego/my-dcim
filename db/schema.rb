# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170626123240) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actes", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree
  end

  create_table "architectures", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "bay_types", force: :cascade do |t|
    t.string  "name"
    t.integer "size"
  end

  create_table "bays", force: :cascade do |t|
    t.string   "name"
    t.integer  "lane"
    t.integer  "position"
    t.integer  "bay_type_id"
    t.integer  "islet_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["bay_type_id"], name: "index_bays_on_bay_type_id", using: :btree
    t.index ["islet_id"], name: "index_bays_on_islet_id", using: :btree
  end

  create_table "cards", force: :cascade do |t|
    t.string  "name"
    t.integer "port_type_id"
    t.integer "port_quantity"
    t.index ["port_type_id"], name: "index_cards_on_port_type_id", using: :btree
  end

  create_table "cards_servers", force: :cascade do |t|
    t.integer "card_id"
    t.integer "server_id"
    t.integer "composant_id"
    t.index ["card_id"], name: "index_cards_servers_on_card_id", using: :btree
    t.index ["composant_id"], name: "index_cards_servers_on_composant_id", using: :btree
    t.index ["server_id"], name: "index_cards_servers_on_server_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "clusters", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "colors", force: :cascade do |t|
    t.string   "parent_type"
    t.string   "parent_id"
    t.string   "code"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "composants", force: :cascade do |t|
    t.integer  "modele_id"
    t.integer  "type_composant_id"
    t.integer  "position"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "name"
    t.index ["modele_id"], name: "index_composants_on_modele_id", using: :btree
    t.index ["type_composant_id"], name: "index_composants_on_type_composant_id", using: :btree
  end

  create_table "contract_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "disk_types", force: :cascade do |t|
    t.integer  "quantity"
    t.string   "unit"
    t.string   "technology"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "disks", force: :cascade do |t|
    t.integer  "server_id"
    t.integer  "disk_type_id"
    t.integer  "quantity"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["disk_type_id"], name: "index_disks_on_disk_type_id", using: :btree
    t.index ["server_id"], name: "index_disks_on_server_id", using: :btree
  end

  create_table "domaines", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "frames", force: :cascade do |t|
    t.string   "name"
    t.integer  "u",           default: 41
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "position"
    t.integer  "switch_slot"
    t.string   "slug"
    t.integer  "bay_id"
    t.index ["bay_id"], name: "index_frames_on_bay_id", using: :btree
    t.index ["slug"], name: "index_frames_on_slug", unique: true, using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "gestions", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "islets", force: :cascade do |t|
    t.string   "name"
    t.integer  "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_islets_on_room_id", using: :btree
  end

  create_table "maintainers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "maintenance_contracts", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "maintainer_id"
    t.integer  "contract_type_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "server_id"
    t.index ["contract_type_id"], name: "index_maintenance_contracts_on_contract_type_id", using: :btree
    t.index ["maintainer_id"], name: "index_maintenance_contracts_on_maintainer_id", using: :btree
    t.index ["server_id"], name: "index_maintenance_contracts_on_server_id", using: :btree
  end

  create_table "marques", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "memory_components", force: :cascade do |t|
    t.integer  "server_id"
    t.integer  "memory_type_id"
    t.integer  "quantity"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["memory_type_id"], name: "index_memory_components_on_memory_type_id", using: :btree
    t.index ["server_id"], name: "index_memory_components_on_server_id", using: :btree
  end

  create_table "memory_types", force: :cascade do |t|
    t.integer  "quantity"
    t.string   "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "modeles", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "category_id"
    t.integer  "nb_elts"
    t.integer  "architecture_id"
    t.integer  "u"
    t.integer  "marque_id"
    t.string   "color"
    t.string   "slug"
    t.index ["architecture_id"], name: "index_modeles_on_architecture_id", using: :btree
    t.index ["category_id"], name: "index_modeles_on_category_id", using: :btree
    t.index ["marque_id"], name: "index_modeles_on_marque_id", using: :btree
    t.index ["slug"], name: "index_modeles_on_slug", unique: true, using: :btree
  end

  create_table "pdu_lines", force: :cascade do |t|
    t.integer  "pdu_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pdu_id"], name: "index_pdu_lines_on_pdu_id", using: :btree
  end

  create_table "pdu_outlet_groups", force: :cascade do |t|
    t.integer  "pdu_line_id"
    t.string   "name"
    t.integer  "nb_of_outlets", default: 12
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["pdu_line_id"], name: "index_pdu_outlet_groups_on_pdu_line_id", using: :btree
  end

  create_table "pdus", force: :cascade do |t|
    t.integer  "frame_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["frame_id"], name: "index_pdus_on_frame_id", using: :btree
  end

  create_table "port_types", force: :cascade do |t|
    t.string "name"
  end

  create_table "ports", force: :cascade do |t|
    t.integer  "position"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "vlans"
    t.string   "color"
    t.string   "cablename"
    t.index ["parent_id", "parent_type"], name: "index_ports_on_parent_id_and_parent_type", using: :btree
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "slug"
    t.integer  "position"
    t.boolean  "display_on_home_page"
    t.integer  "site_id"
    t.index ["site_id"], name: "index_rooms_on_site_id", using: :btree
    t.index ["slug"], name: "index_rooms_on_slug", unique: true, using: :btree
  end

  create_table "server_states", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "servers", force: :cascade do |t|
    t.string   "name"
    t.integer  "modele_id"
    t.string   "numero"
    t.integer  "conso"
    t.boolean  "critique"
    t.integer  "domaine_id"
    t.integer  "gestion_id"
    t.integer  "acte_id"
    t.integer  "fc_total"
    t.integer  "fc_utilise"
    t.integer  "rj45_total"
    t.integer  "rj45_utilise"
    t.integer  "rj45_futur"
    t.integer  "ipmi_utilise"
    t.integer  "ipmi_futur"
    t.integer  "rj45_cm"
    t.integer  "ipmi_dedie"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "pdu_ondule"
    t.string   "pdu_normal"
    t.integer  "frame_id"
    t.integer  "fc_calcule"
    t.integer  "fc_futur"
    t.string   "i"
    t.integer  "rj45_calcule"
    t.integer  "tenGbps_futur"
    t.string   "ip"
    t.string   "hostname"
    t.string   "etat_conf_reseau"
    t.string   "action_conf_reseau"
    t.integer  "position"
    t.integer  "cluster_id"
    t.integer  "server_state_id"
    t.string   "comment"
    t.string   "slug"
    t.string   "port_color"
    t.index ["acte_id"], name: "index_servers_on_acte_id", using: :btree
    t.index ["cluster_id"], name: "index_servers_on_cluster_id", using: :btree
    t.index ["domaine_id"], name: "index_servers_on_domaine_id", using: :btree
    t.index ["frame_id"], name: "index_servers_on_frame_id", using: :btree
    t.index ["gestion_id"], name: "index_servers_on_gestion_id", using: :btree
    t.index ["modele_id"], name: "index_servers_on_modele_id", using: :btree
    t.index ["server_state_id"], name: "index_servers_on_server_state_id", using: :btree
    t.index ["slug"], name: "index_servers_on_slug", unique: true, using: :btree
  end

  create_table "sites", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slots", force: :cascade do |t|
    t.integer  "position"
    t.string   "valeur"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "composant_id"
    t.integer  "server_id"
    t.index ["composant_id"], name: "index_slots_on_composant_id", using: :btree
    t.index ["server_id"], name: "index_slots_on_server_id", using: :btree
  end

  create_table "type_composants", force: :cascade do |t|
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "role"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
    t.index ["invited_by_id", "invited_by_type"], name: "index_users_on_invited_by_id_and_invited_by_type", using: :btree
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
