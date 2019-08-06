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

ActiveRecord::Schema.define(version: 2019_08_06_144115) do

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.string "commentable_type"
    t.integer "commentable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "counties", force: :cascade do |t|
    t.integer "state_id"
    t.string "abbr"
    t.string "name"
    t.string "county_seat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_counties_on_name"
    t.index ["state_id"], name: "index_counties_on_state_id"
  end

  create_table "milestones", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "complete"
    t.string "current_status"
    t.integer "problem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id"], name: "index_milestones_on_problem_id"
  end

  create_table "problems", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "location"
    t.datetime "target_completion_date"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city", default: "", null: false
    t.string "zip", default: "", null: false
    t.string "state", default: "", null: false
    t.string "country", default: "United States", null: false
    t.index ["user_id"], name: "index_problems_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.integer "role_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "problem_id"
    t.index ["problem_id"], name: "index_roles_on_problem_id"
    t.index ["user_id", "problem_id"], name: "index_roles_on_user_id_and_problem_id", unique: true
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "abbr", limit: 2
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["abbr"], name: "index_states_on_abbr"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "city", default: "", null: false
    t.string "zip", default: "", null: false
    t.string "state", default: "", null: false
    t.string "country", default: "United States", null: false
    t.integer "followed_problems_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["followed_problems_id"], name: "index_users_on_followed_problems_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "zipcodes", force: :cascade do |t|
    t.string "code"
    t.string "city"
    t.integer "state_id"
    t.integer "county_id"
    t.string "area_code"
    t.decimal "lat", precision: 15, scale: 10
    t.decimal "lon", precision: 15, scale: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_zipcodes_on_code"
    t.index ["county_id"], name: "index_zipcodes_on_county_id"
    t.index ["lat", "lon"], name: "index_zipcodes_on_lat_and_lon"
    t.index ["state_id"], name: "index_zipcodes_on_state_id"
  end

end
