# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_05_28_130755) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "air_conditioner_models", force: :cascade do |t|
    t.string "name"
    t.bigint "manufacturer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manufacturer_id"], name: "index_air_conditioner_models_on_manufacturer_id"
  end

  create_table "air_conditioners", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.date "last_service"
    t.bigint "air_conditioner_model_id", null: false
    t.bigint "bay_id", null: false
    t.string "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "start"
    t.integer "range"
    t.integer "setpoint"
    t.integer "min_setpoint"
    t.boolean "lift_pump", default: false, null: false
    t.index ["air_conditioner_model_id"], name: "index_air_conditioners_on_air_conditioner_model_id"
    t.index ["bay_id"], name: "index_air_conditioners_on_bay_id"
  end

  create_table "architectures", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "modeles_count", default: 0, null: false
  end

  create_table "bay_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "size"
  end

  create_table "bays", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "lane"
    t.integer "position"
    t.integer "bay_type_id", null: false
    t.integer "islet_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "access_control"
    t.integer "width"
    t.integer "depth"
    t.bigint "manufacturer_id"
    t.index ["bay_type_id"], name: "index_bays_on_bay_type_id"
    t.index ["islet_id"], name: "index_bays_on_islet_id"
    t.index ["manufacturer_id"], name: "index_bays_on_manufacturer_id"
  end

  create_table "cables", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "comments"
    t.boolean "special_case"
  end

  create_table "card_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "port_type_id", null: false
    t.integer "port_quantity"
    t.integer "columns"
    t.integer "rows"
    t.integer "max_aligned_ports"
    t.integer "first_position"
    t.index ["port_type_id"], name: "index_card_types_on_port_type_id"
  end

  create_table "cards", id: :serial, force: :cascade do |t|
    t.integer "card_type_id", null: false
    t.integer "server_id", null: false
    t.integer "composant_id"
    t.integer "twin_card_id"
    t.string "orientation"
    t.string "name"
    t.integer "first_position"
    t.index ["card_type_id"], name: "index_cards_on_card_type_id"
    t.index ["composant_id"], name: "index_cards_on_composant_id"
    t.index ["server_id"], name: "index_cards_on_server_id"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "modeles_count", default: 0, null: false
    t.boolean "is_glpi_synchronizable", default: false, null: false
  end

  create_table "changelog_entries", force: :cascade do |t|
    t.string "object_type", null: false
    t.bigint "object_id", null: false
    t.string "author_type"
    t.bigint "author_id"
    t.string "action", null: false
    t.jsonb "object_changed_attributes", default: {}, null: false
    t.jsonb "metadata", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_changelog_entries_on_author"
    t.index ["author_type", "author_id"], name: "index_changelog_entries_on_author_type_and_author_id"
    t.index ["object_type", "object_id"], name: "index_changelog_entries_on_object"
    t.index ["object_type", "object_id"], name: "index_changelog_entries_on_object_type_and_object_id"
  end

  create_table "cluster_rooms", force: :cascade do |t|
    t.bigint "cluster_id", null: false
    t.bigint "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cluster_id"], name: "index_cluster_rooms_on_cluster_id"
    t.index ["room_id"], name: "index_cluster_rooms_on_room_id"
  end

  create_table "clusters", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "servers_count", default: 0, null: false
  end

  create_table "colors", id: :serial, force: :cascade do |t|
    t.string "parent_type"
    t.string "parent_id"
    t.string "code"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["parent_id"], name: "index_colors_on_parent_id"
  end

  create_table "composants", id: :serial, force: :cascade do |t|
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "name"
    t.integer "enclosure_id"
    t.index ["enclosure_id"], name: "index_composants_on_enclosure_id"
  end

  create_table "connections", id: :serial, force: :cascade do |t|
    t.integer "cable_id", null: false
    t.integer "port_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["cable_id", "port_id"], name: "index_connections_on_cable_id_and_port_id", unique: true
    t.index ["port_id"], name: "index_connections_on_port_id"
  end

  create_table "contact_assignments", force: :cascade do |t|
    t.bigint "site_id", null: false
    t.bigint "contact_id", null: false
    t.bigint "contact_role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_contact_assignments_on_contact_id"
    t.index ["contact_role_id"], name: "index_contact_assignments_on_contact_role_id"
    t.index ["site_id"], name: "index_contact_assignments_on_site_id"
  end

  create_table "contact_roles", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "organization"
  end

  create_table "documents", id: :serial, force: :cascade do |t|
    t.integer "server_id", null: false
    t.text "document_data"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["server_id"], name: "index_documents_on_server_id"
  end

  create_table "domaines", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "servers_count", default: 0, null: false
  end

  create_table "enclosures", id: :serial, force: :cascade do |t|
    t.integer "modele_id", null: false
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "display", default: "vertical", null: false
    t.text "grid_areas"
    t.index ["modele_id"], name: "index_enclosures_on_modele_id"
  end

  create_table "external_app_records", force: :cascade do |t|
    t.bigint "server_id", null: false
    t.string "app_name"
    t.string "external_name"
    t.string "external_id"
    t.string "external_serial"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["server_id"], name: "index_external_app_records_on_server_id"
  end

  create_table "external_app_requests", force: :cascade do |t|
    t.string "status"
    t.integer "progress"
    t.string "external_app_name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_external_app_requests_on_user_id"
  end

  create_table "frames", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "u", default: 41
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "position"
    t.integer "switch_slot"
    t.string "slug"
    t.integer "bay_id", null: false
    t.float "width"
    t.index ["bay_id"], name: "index_frames_on_bay_id"
    t.index ["slug"], name: "index_frames_on_slug", unique: true
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at", precision: nil
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "gestions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "servers_count", default: 0, null: false
  end

  create_table "islets", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "room_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "position"
    t.text "description"
    t.integer "cooling_mode"
    t.integer "access_control"
    t.index ["room_id"], name: "index_islets_on_room_id"
  end

  create_table "manufacturers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "documentation_url"
    t.integer "modeles_count", default: 0, null: false
    t.integer "bays_count", default: 0, null: false
  end

  create_table "modeles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "category_id", null: false
    t.integer "nb_elts"
    t.integer "architecture_id"
    t.integer "u"
    t.integer "manufacturer_id"
    t.string "color"
    t.string "slug"
    t.integer "servers_count", default: 0, null: false
    t.string "network_types", default: [], array: true
    t.index ["architecture_id"], name: "index_modeles_on_architecture_id"
    t.index ["category_id"], name: "index_modeles_on_category_id"
    t.index ["manufacturer_id"], name: "index_modeles_on_manufacturer_id"
    t.index ["slug"], name: "index_modeles_on_slug", unique: true
  end

  create_table "moved_connections", id: :serial, force: :cascade do |t|
    t.integer "port_from_id"
    t.integer "port_to_id"
    t.string "vlans"
    t.string "cablename"
    t.string "color"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["port_from_id"], name: "index_moved_connections_on_port_from_id"
    t.index ["port_to_id"], name: "index_moved_connections_on_port_to_id"
  end

  create_table "moves", id: :serial, force: :cascade do |t|
    t.string "moveable_type", null: false
    t.integer "moveable_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "prev_frame_id", null: false
    t.integer "frame_id", null: false
    t.integer "position"
    t.bigint "moves_project_step_id", null: false
    t.datetime "executed_at"
    t.index ["frame_id"], name: "index_moves_on_frame_id"
    t.index ["moveable_type", "moveable_id"], name: "index_moves_on_moveable_type_and_moveable_id"
    t.index ["moves_project_step_id"], name: "index_moves_on_moves_project_step_id"
    t.index ["prev_frame_id"], name: "index_moves_on_prev_frame_id"
  end

  create_table "moves_project_steps", force: :cascade do |t|
    t.bigint "moves_project_id", null: false
    t.string "name", null: false
    t.integer "position", default: 1, null: false
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["moves_project_id"], name: "index_moves_project_steps_on_moves_project_id"
  end

  create_table "moves_projects", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "port_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "power"
    t.integer "card_types_count", default: 0, null: false
  end

  create_table "ports", id: :serial, force: :cascade do |t|
    t.integer "position"
    t.integer "card_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "vlans"
    t.string "color"
    t.string "cablename"
    t.index ["card_id"], name: "index_ports_on_card_id"
  end

  create_table "rooms", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug"
    t.integer "position"
    t.boolean "display_on_home_page"
    t.integer "site_id", null: false
    t.integer "islets_count", default: 0
    t.integer "status", default: 0, null: false
    t.integer "surface_area"
    t.integer "access_control"
    t.index ["site_id"], name: "index_rooms_on_site_id"
    t.index ["slug"], name: "index_rooms_on_slug", unique: true
  end

  create_table "servers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "modele_id"
    t.string "numero"
    t.boolean "critique"
    t.integer "domaine_id"
    t.integer "gestion_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "frame_id", null: false
    t.integer "position"
    t.integer "cluster_id"
    t.string "comment"
    t.string "slug"
    t.string "side"
    t.string "color"
    t.integer "stack_id"
    t.string "network_types", default: [], array: true
    t.index ["cluster_id"], name: "index_servers_on_cluster_id"
    t.index ["domaine_id"], name: "index_servers_on_domaine_id"
    t.index ["frame_id"], name: "index_servers_on_frame_id"
    t.index ["gestion_id"], name: "index_servers_on_gestion_id"
    t.index ["modele_id"], name: "index_servers_on_modele_id"
    t.index ["numero"], name: "index_servers_on_numero", unique: true
    t.index ["slug"], name: "index_servers_on_slug", unique: true
  end

  create_table "sites", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "street"
    t.string "city"
    t.string "country"
    t.decimal "latitude"
    t.decimal "longitude"
    t.integer "rooms_count", default: 0, null: false
    t.text "description"
    t.text "delivery_address"
    t.text "delivery_times"
  end

  create_table "stacks", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "servers_count", default: 0, null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "name"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.integer "role"
    t.string "invitation_token"
    t.datetime "invitation_created_at", precision: nil
    t.datetime "invitation_sent_at", precision: nil
    t.datetime "invitation_accepted_at", precision: nil
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "authentication_token", limit: 30
    t.datetime "suspended_at"
    t.jsonb "settings", default: {}
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id", "invited_by_type"], name: "index_users_on_invited_by_id_and_invited_by_type"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "air_conditioner_models", "manufacturers"
  add_foreign_key "air_conditioners", "air_conditioner_models"
  add_foreign_key "air_conditioners", "bays"
  add_foreign_key "bays", "bay_types"
  add_foreign_key "bays", "islets"
  add_foreign_key "bays", "manufacturers"
  add_foreign_key "card_types", "port_types"
  add_foreign_key "cards", "card_types"
  add_foreign_key "cluster_rooms", "clusters"
  add_foreign_key "cluster_rooms", "rooms"
  add_foreign_key "connections", "cables"
  add_foreign_key "contact_assignments", "contact_roles"
  add_foreign_key "contact_assignments", "contacts"
  add_foreign_key "contact_assignments", "sites"
  add_foreign_key "documents", "servers"
  add_foreign_key "external_app_records", "servers"
  add_foreign_key "external_app_requests", "users"
  add_foreign_key "frames", "bays"
  add_foreign_key "modeles", "architectures"
  add_foreign_key "modeles", "categories"
  add_foreign_key "modeles", "manufacturers"
  add_foreign_key "moves", "frames"
  add_foreign_key "moves", "frames", column: "prev_frame_id"
  add_foreign_key "moves", "moves_project_steps"
  add_foreign_key "moves_project_steps", "moves_projects"
  add_foreign_key "rooms", "sites"
  add_foreign_key "servers", "clusters"
  add_foreign_key "servers", "gestions"
  add_foreign_key "servers", "modeles"
  add_foreign_key "servers", "stacks"

  create_view "servers_frames_view", sql_definition: <<-SQL
      SELECT s.id,
      s.name,
      s.numero,
      mo.name AS modele_name,
      m.name AS manufacturer_name,
      NULL::character varying AS islet_name,
      NULL::character varying AS room_name,
      'Server'::text AS record_type
     FROM ((servers s
       LEFT JOIN modeles mo ON ((mo.id = s.modele_id)))
       LEFT JOIN manufacturers m ON ((m.id = mo.manufacturer_id)))
  UNION ALL
   SELECT f.id,
      f.name,
      NULL::character varying AS numero,
      NULL::character varying AS modele_name,
      NULL::character varying AS manufacturer_name,
      ( SELECT i.name
             FROM islets i
            WHERE (i.id = f.id)
           LIMIT 1) AS islet_name,
      ( SELECT r.name
             FROM rooms r
            WHERE (r.id = f.id)
           LIMIT 1) AS room_name,
      'Frame'::text AS record_type
     FROM frames f;
  SQL
end
