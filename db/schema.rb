# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_13_024249) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "record_id"
    t.index ["name", "record_type", "record_id"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.uuid "record_id"
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "post_id"
    t.text "content"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "author_id"
    t.uuid "receiver_id"
    t.index ["author_id", "receiver_id"], name: "index_conversations_on_author_id_and_receiver_id", unique: true
    t.index ["author_id"], name: "index_conversations_on_author_id"
    t.index ["receiver_id"], name: "index_conversations_on_receiver_id"
  end

  create_table "costs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.date "fetch_date", default: -> { "CURRENT_TIMESTAMP" }
    t.float "daily_cost"
    t.float "mtd_cost"
    t.float "estimated_monthly_cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fetch_date"], name: "index_costs_on_fetch_date"
  end

  create_table "donations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.boolean "marketing", default: true
    t.boolean "donate", default: true
    t.index ["email"], name: "index_donations_on_email"
  end

  create_table "geopoints", force: :cascade do |t|
    t.string "zip"
    t.string "city"
    t.string "state"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.integer "time_zone"
    t.boolean "dst_flag"
    t.string "coordinates"
    t.index ["zip"], name: "index_geopoints_on_zip"
  end

  create_table "notifications", force: :cascade do |t|
    t.uuid "recipient_id"
    t.uuid "actor_id"
    t.datetime "read_at"
    t.string "action"
    t.uuid "notifiable_id"
    t.string "notifiable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "opportunities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.datetime "target_completion_date"
    t.integer "volunteers_required", default: 1
    t.integer "volunteer_count", default: 1
    t.boolean "completed", default: false
    t.string "address"
    t.string "postal_code"
    t.integer "follower_count", default: 1
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "recurring", default: false
    t.string "status"
    t.uuid "last_edited_by"
    t.string "time_zone"
    t.uuid "organization_id"
    t.index ["latitude", "longitude"], name: "index_opportunities_on_latitude_and_longitude"
    t.index ["user_id"], name: "index_opportunities_on_user_id"
  end

  create_table "opportunity_roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "level"
    t.string "title"
    t.string "note"
    t.uuid "user_id"
    t.uuid "opportunity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_responded", default: false
    t.boolean "is_coming", default: false
    t.integer "additional_vols", default: 0
    t.boolean "self_verified"
    t.boolean "leader_verified"
    t.boolean "leader_was_present"
    t.datetime "self_verified_at"
    t.datetime "leader_verified_at"
    t.index ["opportunity_id"], name: "index_opportunity_roles_on_opportunity_id"
    t.index ["user_id", "opportunity_id"], name: "index_opportunity_roles_on_user_id_and_opportunity_id", unique: true
    t.index ["user_id"], name: "index_opportunity_roles_on_user_id"
  end

  create_table "organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.string "region"
    t.string "country"
    t.string "website"
    t.uuid "user_id"
    t.index ["user_id"], name: "index_organizations_on_user_id"
  end

  create_table "personal_messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "body"
    t.bigint "conversation_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["conversation_id"], name: "index_personal_messages_on_conversation_id"
    t.index ["user_id"], name: "index_personal_messages_on_user_id"
  end

  create_table "posts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "comment_count", default: 0
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "content"
    t.boolean "archived", default: false
    t.boolean "completion_post", default: false
    t.uuid "opportunity_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "reported_errors", force: :cascade do |t|
    t.string "source"
    t.text "errs"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priority"], name: "index_reported_errors_on_priority"
    t.index ["source"], name: "index_reported_errors_on_source"
  end

  create_table "requirement_roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "level"
    t.string "title"
    t.string "note"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "requirement_id"
    t.uuid "opportunity_id"
    t.index ["user_id", "opportunity_id"], name: "index_requirement_roles_on_user_id_and_opportunity_id"
    t.index ["user_id", "requirement_id"], name: "idx_one_role_per_user", unique: true
    t.index ["user_id"], name: "index_requirement_roles_on_user_id"
  end

  create_table "requirements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "address"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.integer "volunteers_required", default: 1
    t.integer "volunteer_count", default: 0
    t.integer "category"
    t.integer "subcategory"
    t.boolean "complete"
    t.string "status"
    t.uuid "opportunity_id"
    t.uuid "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority", default: 1
    t.float "estimated_work", default: 1.0
    t.float "pct_done", default: 100.0
    t.date "target_completion_date"
    t.boolean "defined", default: true
    t.uuid "last_edited_by"
    t.string "time_zone"
    t.uuid "leader_id"
    t.index ["category", "subcategory"], name: "index_requirements_on_category_and_subcategory"
    t.index ["creator_id"], name: "index_requirements_on_creator_id"
    t.index ["latitude", "longitude"], name: "index_requirements_on_latitude_and_longitude"
    t.index ["opportunity_id"], name: "index_requirements_on_opportunity_id"
  end

  create_table "user_organizations", force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "organization_id"
    t.index ["organization_id"], name: "index_user_organizations_on_organization_id"
    t.index ["user_id"], name: "index_user_organizations_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "city"
    t.string "postal_code"
    t.string "region"
    t.string "country", default: "United States"
    t.string "phone_number"
    t.date "birth_date"
    t.boolean "over_16"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "time_zone"
    t.boolean "allow_email", default: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "personal_messages", "conversations"
  add_foreign_key "personal_messages", "users"
end
