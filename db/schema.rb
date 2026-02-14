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

ActiveRecord::Schema[8.1].define(version: 2026_02_14_132843) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["username"], name: "index_admins_on_username", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.time "end_time", null: false
    t.date "event_date", null: false
    t.string "location", null: false
    t.integer "required_number_of_volunteers", null: false
    t.time "start_time", null: false
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["event_date"], name: "index_events_on_event_date"
    t.index ["status"], name: "index_events_on_status"
  end

  create_table "volunteer_assignments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date_logged"
    t.bigint "event_id", null: false
    t.decimal "hours_worked", precision: 6, scale: 2
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "volunteer_id", null: false
    t.index ["event_id"], name: "index_volunteer_assignments_on_event_id"
    t.index ["volunteer_id", "event_id"], name: "index_volunteer_assignments_on_volunteer_and_event", unique: true
    t.index ["volunteer_id"], name: "index_volunteer_assignments_on_volunteer_id"
    t.check_constraint "hours_worked IS NULL OR hours_worked >= 0::numeric", name: "chk_volunteer_assignments_hours_non_negative"
  end

  create_table "volunteers", force: :cascade do |t|
    t.text "address"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "full_name", null: false
    t.string "password_digest", null: false
    t.string "phone_number"
    t.text "skills_interests"
    t.decimal "total_hours", precision: 8, scale: 2, default: "0.0"
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email"], name: "index_volunteers_on_email", unique: true
    t.index ["username"], name: "index_volunteers_on_username", unique: true
  end

  add_foreign_key "volunteer_assignments", "events"
  add_foreign_key "volunteer_assignments", "volunteers"
end
