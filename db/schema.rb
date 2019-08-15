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

ActiveRecord::Schema.define(version: 2019_08_15_164827) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "post_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "costs", force: :cascade do |t|
    t.date "fetch_date", default: -> { "CURRENT_TIMESTAMP" }
    t.float "daily_cost"
    t.float "mtd_cost"
    t.float "estimated_monthly_cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "donations", force: :cascade do |t|
    t.string "email"
    t.boolean "donate"
    t.boolean "marketing"
    t.boolean "volunteer"
  end

  create_table "geopoints", force: :cascade do |t|
    t.string "zip"
    t.string "city"
    t.string "state"
    t.decimal "latitude", precision: 9, scale: 6
    t.decimal "longitude", precision: 9, scale: 6
    t.integer "time_zone"
    t.boolean "dst_flag"
    t.string "coordinates"
    t.index ["zip"], name: "index_geopoints_on_zip", unique: true
  end

  create_table "milestone_roles", force: :cascade do |t|
    t.integer "level"
    t.string "title"
    t.bigint "milestone_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["milestone_id", "user_id"], name: "index_milestone_roles_on_milestone_id_and_user_id", unique: true
    t.index ["milestone_id"], name: "index_milestone_roles_on_milestone_id"
    t.index ["user_id"], name: "index_milestone_roles_on_user_id"
  end

  create_table "milestones", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "complete"
    t.string "current_status"
    t.bigint "problem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.bigint "user_id"
    t.integer "participants_required", default: 1
    t.integer "participant_count", default: 1
    t.index ["problem_id"], name: "index_milestones_on_problem_id"
    t.index ["user_id"], name: "index_milestones_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", default: "Change me!", null: false
    t.text "content", default: "Add content!", null: false
    t.bigint "user_id"
    t.string "postable_type"
    t.bigint "postable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "comment_count", default: 0
    t.index ["postable_type", "postable_id"], name: "index_posts_on_postable_type_and_postable_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "problems", force: :cascade do |t|
    t.string "title", default: "Default Title. Change me!", null: false
    t.text "description", default: "This is the default description. Please change me!", null: false
    t.float "latitude"
    t.float "longitude"
    t.date "target_completion_date"
    t.bigint "user_id"
    t.integer "participants_required", default: 1
    t.integer "participant_count", default: 1
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.string "category"
    t.string "subcategory"
    t.integer "follower_count", default: 1
    t.string "postal_code"
    t.string "country", default: "United States"
    t.index ["user_id"], name: "index_problems_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.integer "level"
    t.string "title"
    t.bigint "user_id"
    t.bigint "problem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id"], name: "index_roles_on_problem_id"
    t.index ["user_id", "problem_id"], name: "index_roles_on_user_id_and_problem_id", unique: true
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "city", default: "", null: false
    t.string "zip", default: "", null: false
    t.string "state", default: "", null: false
    t.string "country", default: "United States", null: false
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
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "problems", "users"
end
