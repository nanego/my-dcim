# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160906100059) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actes", force: :cascade do |t|
    t.string   "title"
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
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "architectures", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "armoires", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "baies", force: :cascade do |t|
    t.string   "title"
    t.integer  "u",           default: 41
    t.integer  "salle_id"
    t.integer  "ilot"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "position"
    t.integer  "switch_slot"
    t.string   "slug"
  end

  add_index "baies", ["slug"], name: "index_baies_on_slug", unique: true, using: :btree

  create_table "cards", force: :cascade do |t|
    t.string  "name"
    t.integer "port_type_id"
    t.integer "port_quantity"
  end

  create_table "cards_serveurs", force: :cascade do |t|
    t.integer "card_id"
    t.integer "serveur_id"
    t.integer "composant_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "clusters", force: :cascade do |t|
    t.string   "title"
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
  end

  create_table "connections", force: :cascade do |t|
    t.integer  "source_port_id"
    t.integer  "destination_port_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "couple_baies", force: :cascade do |t|
    t.integer  "baie_one_id"
    t.integer  "baie_two_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "domaines", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "gestions", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "localisations", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "marques", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "modeles", force: :cascade do |t|
    t.string   "title"
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
  end

  add_index "modeles", ["slug"], name: "index_modeles_on_slug", unique: true, using: :btree

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
  end

  create_table "salles", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "slug"
    t.integer  "position"
    t.boolean  "display_on_home_page"
  end

  add_index "salles", ["slug"], name: "index_salles_on_slug", unique: true, using: :btree

  create_table "server_states", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "serveurs", force: :cascade do |t|
    t.integer  "localisation_id"
    t.integer  "armoire_id"
    t.string   "nom"
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
    t.integer  "baie_id"
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
  end

  add_index "serveurs", ["slug"], name: "index_serveurs_on_slug", unique: true, using: :btree

  create_table "slots", force: :cascade do |t|
    t.integer  "position"
    t.string   "valeur"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "composant_id"
    t.integer  "serveur_id"
  end

  create_table "type_composants", force: :cascade do |t|
    t.string "title"
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
