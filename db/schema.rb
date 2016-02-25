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

ActiveRecord::Schema.define(version: 20160224155811) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actes", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

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

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "composants", force: :cascade do |t|
    t.integer  "modele_id"
    t.integer  "type_composant_id"
    t.integer  "position"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "domaines", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

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
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "salles", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "published"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "serveurs", force: :cascade do |t|
    t.integer  "localisation_id"
    t.integer  "armoire_id"
    t.integer  "categorie_id"
    t.string   "nom"
    t.integer  "nb_elts"
    t.integer  "architecture_id"
    t.integer  "u"
    t.integer  "marque_id"
    t.integer  "modele_id"
    t.string   "numero"
    t.integer  "conso"
    t.boolean  "cluster"
    t.boolean  "critique"
    t.integer  "domaine_id"
    t.integer  "gestion_id"
    t.integer  "acte_id"
    t.integer  "phase"
    t.integer  "salle_id"
    t.integer  "ilot"
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
    t.integer  "baie"
    t.string   "id_baie"
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
  end

  create_table "slots", force: :cascade do |t|
    t.integer  "numero"
    t.integer  "serveur_id"
    t.string   "valeur"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
